class Calamity
  include ActiveModel::Model

  attr_reader :id, :name, :team_id, :location, :scheduled_at, :deleted_at

  def self.all
    Event.all.select do |event|
      event.name == 'CalamityCreate'
    end.collect do |event|
      calamity = Calamity.new(id: event.data[:calamity_id],
                   name: event.data[:name],
                   team_id: event.data[:team_id],
                   location: event.data[:location],
                   scheduled_at: event.data[:scheduled_at])
      apply_event_changes!(calamity)
      remove_deleted!(calamity)
    end.compact
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == 'CalamityCreate' && event.data[:calamity_id] == id
    end

    @calamity = Calamity.new(id: event.data[:calamity_id],
                             team_id: event.data[:team_id],
                             name: event.data[:name],
                             location: event.data[:location],
                             scheduled_at: event.data[:scheduled_at])
    apply_event_changes!(@calamity)
    remove_deleted!(@calamity)
  end

  def self.apply_event_changes!(calamity)
    Event.all.select do |event|
      event.data[:calamity_id] == calamity.id && (event.name == 'CalamityUpdate' || event.name == 'CalamityDestroy')
    end.each do |event|
      calamity.apply_event_change!(event)
    end

    calamity
  end

  def self.remove_deleted!(calamity)
    if calamity.deleted_at.present?
      nil
    else
      calamity
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @team_id = attributes[:team_id]
    @location = attributes[:location]
    @scheduled_at = DateTime.parse(attributes[:scheduled_at]) if attributes[:scheduled_at]
    @deleted_at = DateTime.parse(attributes[:deleted_at]) if attributes[:deleted_at]
  end

  def apply_event_change!(event)
    @name = event.data[:name] if event.data[:name]
    @location = event.data[:location] if event.data[:location]
    @scheduled_at = event.data[:scheduled_at] if event.data[:scheduled_at]
    @deleted_at = event.data[:deleted_at] if event.data[:deleted_at]
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end

  def team_name
    team.name
  end

  def team
    @team ||= Team.find(@team_id)
  end
end
