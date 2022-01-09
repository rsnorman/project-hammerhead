module Commands
  class CreateCalamity
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @name = attributes[:name]
      @location = attributes[:location]
      @scheduled_at = attributes[:scheduled_at]
      @team_id = attributes[:team_id]
    end

    def execute
      Event.create!(name: 'CalamityCreate', data: {
        name: @name,
        location: @location,
        scheduled_at: @scheduled_at,
        team_id: @team_id,
        calamity_id: SecureRandom.uuid
      })
    end
  end
end