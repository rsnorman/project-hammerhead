module Commands
  class DestroyCalamity
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @calamity = attributes[:calamity]
      @deleted_at = DateTime.current
    end

    def execute
      Event.create!(name: 'CalamityDestroy', data: { calamity_id: @calamity.id, deleted_at: @deleted_at })
    end
  end
end