module Commands
  class CreateCalamity
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @name = attributes[:name]
      @scheduled_at = attributes[:scheduled_at]
    end

    def execute
      Event.create!(name: 'CalamityCreate', data: { name: @name, scheduled_at: @scheduled_at, calamity_id: SecureRandom.uuid })
    end
  end
end