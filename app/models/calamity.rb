class Calamity
  include ActiveModel::Model

  attr_reader :id, :name, :scheduled_at

  def self.all
    Event.all.select do |event|
      event.name == 'CalamityCreate'
    end.collect do |event|
      calamity = Calamity.new(id: event.data[:calamity_id],
                   name: event.data[:name],
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
                             name: event.data[:name],
                             scheduled_at: event.data[:scheduled_at])
    apply_event_changes!(@calamity)
    remove_deleted!(@calamity)
  end

  def self.apply_event_changes!(calamity)
    Event.all.select do |event|
      event.data[:calamity_id] == calamity.id && event.name == 'CalamityUpdate'
    end.each do |event|
      calamity.apply_event_change!(event)
    end

    calamity
  end

  def self.remove_deleted!(calamity)
    destroy_event = Event.all.find do |event|
      event.data[:calamity_id] == calamity.id && event.name == 'CalamityDestroy'
    end

    if destroy_event
      nil
    else
      calamity
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @scheduled_at = DateTime.parse(attributes[:scheduled_at]) if attributes[:scheduled_at]
  end

  def apply_event_change!(event)
    @name = event.data[:name] if event.data[:name]
    @scheduled_at = event.data[:scheduled_at] if event.data[:scheduled_at]
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end
end
