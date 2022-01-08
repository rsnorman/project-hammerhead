module Commands
  class DestroyTeam
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @team = attributes[:team]
      @deleted_at = DateTime.current
    end

    def execute
      Event.create!(name: Team::DESTROY_EVENT_NAME, data: { team_id: @team.id, deleted_at: @deleted_at })
    end
  end
end