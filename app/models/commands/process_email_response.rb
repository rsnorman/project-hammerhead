module Commands
  class ProcessEmailResponse
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @email_response_id = attributes[:email_response_id]
    end

    def execute
      email_response_update_event = Event.create!(name: EmailResponse::UPDATE_EVENT_NAME, data: {
        email: email_body,
        from: from_email,
        email_response_id: @email_response_id
      })

      email_response_update_event
    end

    private
      def email_response
        @email_response ||= EmailResponse.find(@email_response_id)
      end

      def from_email
        email_response.email.split("\n\nOn ").first.split("\n")[1].split('<').last.chomp('>')
      end

      def email_body
        email_response.email.split("\n\nOn ").first.split("\n\n\n").last
      end
  end
end