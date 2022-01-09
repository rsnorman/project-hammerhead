module Commands
  class DestroyTeamMember
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @team_member = attributes[:team_member]
      @deleted_at = DateTime.current
    end

    def execute
      Event.create!(name: TeamMember::DESTROY_EVENT_NAME, data: { team_member_id: @team_member.id, deleted_at: @deleted_at })
    end
  end
end