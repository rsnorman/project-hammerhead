class Attendee
  include ActiveModel::Model

  CREATE_EVENT_NAME = 'AttendeeCreate'
  UPDATE_EVENT_NAME = 'AttendeeUpdate'
  DESTROY_EVENT_NAME = 'AttendeeDestroy'

  ATTENDENCE_STATUSES = %i[ pending accepted declined unsure ]

  attr_reader :id, :calamity_id, :team_id, :status, :deleted_at

  def self.all(calamity_id:)
    Event.all.select do |event|
      event.name == CREATE_EVENT_NAME && event.data[:calamity_id] == calamity_id
    end.collect do |event|
      attendee = Attendee.new(id: event.data[:attendee_id],
                              calamity_id: event.data[:calamity_id],
                              team_member_id: event.data[:team_member_id],
                              status: event.data[:status])
      apply_event_changes!(attendee)
      remove_deleted!(attendee)
    end.compact
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == CREATE_EVENT_NAME && event.data[:attendee_id] == id
    end

    attendee = Attendee.new(id: event.data[:attendee_id],
                            calamity_id: event.data[:calamity_id],
                            team_member_id: event.data[:team_member_id],
                            status: event.data[:status])
    apply_event_changes!(attendee)
    remove_deleted!(attendee)
  end

  def self.apply_event_changes!(attendee)
    Event.all.select do |event|
      event.data[:attendee_id] == attendee.id && (event.name == UPDATE_EVENT_NAME || event.name == DESTROY_EVENT_NAME)
    end.each do |event|
      attendee.apply_event_change!(event)
    end

    attendee
  end

  def self.remove_deleted!(attendee)
    if attendee.deleted_at.present?
      nil
    else
      attendee
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @calamity_id = attributes[:calamity_id]
    @team_member_id = attributes[:team_member_id]
    @status = attributes[:status]
    @deleted_at = DateTime.parse(attributes[:deleted_at]) if attributes[:deleted_at]
  end

  def apply_event_change!(event)
    @status = event.data[:status] if event.data[:status]
    @deleted_at = event.data[:deleted_at] if event.data[:deleted_at]
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end

  def name
    team_member.name
  end

  def team_member
    @team_member ||= TeamMember.find(@team_member_id)
  end
end
