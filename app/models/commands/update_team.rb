module Commands
  class UpdateTeam
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @team = attributes[:team]
      @name = attributes[:name]
    end

    def execute
      Event.create!(name: Team::UPDATE_EVENT_NAME, data: updated_attributes)
    end

    def updated_attributes
      attrs = { team_id: @team.id }
      attrs.merge!(name: @name) unless @team.name == @name
      attrs
    end
  end
end