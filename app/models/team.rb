class Team
  include ActiveModel::Model

  CREATE_EVENT_NAME = 'TeamCreate'
  UPDATE_EVENT_NAME = 'TeamUpdate'
  DESTROY_EVENT_NAME = 'TeamDestroy'

  attr_reader :id, :name, :deleted_at

  def self.all
    Event.all.select do |event|
      event.name == CREATE_EVENT_NAME
    end.collect do |event|
      team = Team.new(id: event.data[:team_id],
                   name: event.data[:name])
      apply_event_changes!(team)
      remove_deleted!(team)
    end.compact
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == CREATE_EVENT_NAME && event.data[:team_id] == id
    end

    @team = Team.new(id: event.data[:team_id],
                             name: event.data[:name])
    apply_event_changes!(@team)
    remove_deleted!(@team)
  end

  def self.apply_event_changes!(team)
    Event.all.select do |event|
      event.data[:team_id] == team.id && (event.name == UPDATE_EVENT_NAME || event.name == DESTROY_EVENT_NAME)
    end.each do |event|
      team.apply_event_change!(event)
    end

    team
  end

  def self.remove_deleted!(team)
    if team.deleted_at.present?
      nil
    else
      team
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
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
end
