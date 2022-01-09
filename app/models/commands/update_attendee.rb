module Commands
  class UpdateAttendee
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @attendee = attributes[:attendee]
      @status = attributes[:status]
    end

    def execute
      Event.create!(name: Attendee::UPDATE_EVENT_NAME, data: updated_attributes)
    end

    def updated_attributes
      attrs = { attendee_id: @attendee.id }
      attrs.merge!(status: @status) unless @attendee.status == @status
      attrs
    end
  end
end