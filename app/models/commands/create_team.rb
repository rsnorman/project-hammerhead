module Commands
  class CreateTeam
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @name = attributes[:name]
    end

    def execute
      Event.create!(name: Team::CREATE_EVENT_NAME, data: { name: @name, team_id: SecureRandom.uuid })
    end
  end
end