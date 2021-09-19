class Calamity
  include ActiveModel::Model

  attr_reader :id, :name

  def self.all
    Event.all.select do |event|
      event.name == 'CalamityCreate'
    end.collect do |event|
      calamity = Calamity.new(id: event.data[:calamity_id],
                   name: event.data[:name],
                   scheduled_at: event.data[:scheduled_at])
      apply_event_changes!(calamity)
    end
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == 'CalamityCreate' && event.data[:calamity_id] == id
    end

    @calamity = Calamity.new(id: event.data[:calamity_id],
                             name: event.data[:name],
                             scheduled_at: event.data[:scheduled_at])
    apply_event_changes!(@calamity)
  end

  def self.apply_event_changes!(calamity)
    Event.all.select do |event|
      event.data[:calamity_id] == calamity.id && event.name == 'CalamityUpdate'
    end.each do |event|
      calamity.apply_event_change!(event)
    end

    calamity
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @scheduled_at = attributes[:scheduled_at]
  end

  def apply_event_change!(event)
    @name = event.data[:name] if event.data[:name]
    @scheduled_at = event.data[:scheduled_at] if event.data[:scheduled_at]
  end

  def scheduled_at
    DateTime.parse(@scheduled_at)
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end
end
