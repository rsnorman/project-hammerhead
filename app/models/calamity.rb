class Calamity
  include ActiveModel::Model

  attr_reader :id, :name, :scheduled_at

  def self.all
    Event.all.select do |event|
      event.name == 'CalamityCreate'
    end.collect do |event|
      Calamity.new(id: event.data[:calamity_id],
                   name: event.data[:name],
                   scheduled_at: event.data[:scheduled_at])
    end
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == 'CalamityCreate' && event.data[:calamity_id] == id
    end

    @calamity = Calamity.new(id: event.data[:calamity_id],
                             name: event.data[:name],
                             scheduled_at: event.data[:scheduled_at])
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @scheduled_at = attributes[:scheduled_at]
  end

  def to_param
    @id.to_s
  end
end
