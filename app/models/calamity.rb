class Calamity
  include ActiveModel::Model

  attr_reader :id, :name, :scheduled_at

  def self.all
    Event.all.select do |event|
      event.name == 'CreateCalamity'
    end.collect do |event|
      Calamity.new(id: event.data['calamity_id'],
                   name: event.data['calamity_name'],
                   scheduled_at: event.data['scheduled_at'])
    end
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
