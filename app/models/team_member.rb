class TeamMember
  include ActiveModel::Model

  CREATE_EVENT_NAME = 'TeamMemberCreate'
  UPDATE_EVENT_NAME = 'TeamMemberUpdate'
  DESTROY_EVENT_NAME = 'TeamMemberDestroy'

  attr_reader :id, :team_id, :name, :email, :deleted_at

  def self.all(team_id:)
    Event.all.select do |event|
      event.name == CREATE_EVENT_NAME && event.data[:team_id] == team_id
    end.collect do |event|
      team_member = TeamMember.new(id: event.data[:team_member_id],
                                   team_id: event.data[:team_id],
                                   name: event.data[:name],
                                   email: event.data[:email])
      apply_event_changes!(team_member)
      remove_deleted!(team_member)
    end.compact
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == CREATE_EVENT_NAME && event.data[:team_member_id] == id
    end

    @team_member = TeamMember.new(id: event.data[:team_member_id],
                                  team_id: event.data[:team_id],
                                  name: event.data[:name],
                                  email: event.data[:email])
    apply_event_changes!(@team_member)
    remove_deleted!(@team_member)
  end

  def self.apply_event_changes!(team_member)
    Event.all.select do |event|
      event.data[:team_member_id] == team_member.id && (event.name == UPDATE_EVENT_NAME || event.name == DESTROY_EVENT_NAME)
    end.each do |event|
      team_member.apply_event_change!(event)
    end

    team_member
  end

  def self.remove_deleted!(team_member)
    if team_member.deleted_at.present?
      nil
    else
      team_member
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @team_id = attributes[:team_id]
    @name = attributes[:name]
    @email = attributes[:email]
    @deleted_at = DateTime.parse(attributes[:deleted_at]) if attributes[:deleted_at]
  end

  def apply_event_change!(event)
    @name = event.data[:name] if event.data[:name]
    @email = event.data[:email] if event.data[:email]
    @deleted_at = event.data[:deleted_at] if event.data[:deleted_at]
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end
end
