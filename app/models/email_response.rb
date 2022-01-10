class EmailResponse
  include ActiveModel::Model

  CREATE_EVENT_NAME = 'EmailResponseCreate'
  UPDATE_EVENT_NAME = 'EmailResponseUpdate'
  DESTROY_EVENT_NAME = 'EmailResponseDestroy'

  attr_reader :id, :calamity_id, :email, :from, :deleted_at

  def self.all(calamity_id:)
    Event.all.select do |event|
      event.name == CREATE_EVENT_NAME && event.data[:calamity_id] == calamity_id
    end.collect do |event|
      email_response = EmailResponse.new(id: event.data[:email_response_id],
                                         calamity_id: event.data[:calamity_id],
                                         email: event.data[:email])
      apply_event_changes!(email_response)
      remove_deleted!(email_response)
    end.compact
  end

  def self.find(id)
    event = Event.all.find do |event|
      event.name == CREATE_EVENT_NAME && event.data[:email_response_id] == id
    end

    email_response = EmailResponse.new(id: event.data[:email_response_id],
                                       calamity_id: event.data[:calamity_id],
                                       email: event.data[:email])
    apply_event_changes!(email_response)
    remove_deleted!(email_response)
  end

  def self.apply_event_changes!(email_response)
    Event.all.select do |event|
      event.data[:email_response_id] == email_response.id && (event.name == UPDATE_EVENT_NAME || event.name == DESTROY_EVENT_NAME)
    end.each do |event|
      email_response.apply_event_change!(event)
    end

    email_response
  end

  def self.remove_deleted!(email_response)
    if email_response.deleted_at.present?
      nil
    else
      email_response
    end
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @calamity_id = attributes[:calamity_id]
    @email = attributes[:email]
    @deleted_at = DateTime.parse(attributes[:deleted_at]) if attributes[:deleted_at]
  end

  def apply_event_change!(event)
    @email = event.data[:email] if event.data[:email]
    @from = event.data[:from] if event.data[:from]
    @deleted_at = event.data[:deleted_at] if event.data[:deleted_at]
  end

  def to_param
    @id.to_s
  end

  def persisted?
    @id.present?
  end
end
