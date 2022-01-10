module Commands
  class CreateEmailResponse
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @calamity_id = attributes[:calamity_id]
      @email = attributes[:plain]
    end

    def execute
      Event.transaction do
        email_response_create_event = Event.create!(name: EmailResponse::CREATE_EVENT_NAME, data: {
          calamity_id: @calamity_id,
          email: @email,
          email_response_id: SecureRandom.uuid
        })

        email_response_create_event
      end
    end
  end
end