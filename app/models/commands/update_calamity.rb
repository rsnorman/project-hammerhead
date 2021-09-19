module Commands
  class UpdateCalamity
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @calamity = attributes[:calamity]
      @name = attributes[:name]
      @scheduled_at = attributes[:scheduled_at]
    end

    def execute
      Event.create!(name: 'CalamityUpdate', data: updated_attributes)
    end

    def updated_attributes
      attrs = { calamity_id: @calamity.id }
      attrs.merge!(name: @name) unless @calamity.name == @name
      attrs.merge!(scheduled_at: @scheduled_at) unless @calamity.scheduled_at == @scheduled_at
      attrs
    end
  end
end