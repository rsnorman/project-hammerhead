module Commands
  class CreateTeamMember
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @team_id = attributes[:team_id]
      @name = attributes[:name]
      @email = attributes[:email]
    end

    def execute
      Event.create!(name: TeamMember::CREATE_EVENT_NAME, data: {
        team_id: @team_id,
        name: @name,
        email: @email,
        team_member_id: SecureRandom.uuid
      })
    end
  end
end