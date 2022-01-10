module Commands
  class CreateEmailResponse
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @calamity_id = attributes[:calamity_id]
      @email = attributes[:email]
      @from = attributes[:from] unless attributes[:from].empty?
    end

    def execute
      email_response_create_event = Event.create!(name: EmailResponse::CREATE_EVENT_NAME, data: {
        calamity_id: @calamity_id,
        email: @email,
        from: @from,
        email_response_id: SecureRandom.uuid
      })

      email_response_create_event
    end
  end
end