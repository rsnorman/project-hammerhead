module Commands
  class UpdateTeamMember
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @team_member = attributes[:team_member]
      @name = attributes[:name]
      @email = attributes[:email]
    end

    def execute
      Event.create!(name: TeamMember::UPDATE_EVENT_NAME, data: updated_attributes)
    end

    def updated_attributes
      attrs = { team_member_id: @team_member.id }
      attrs.merge!(name: @name) unless @team_member.name == @name
      attrs.merge!(location: @email) unless @team_member.email == @email
      attrs
    end
  end
end