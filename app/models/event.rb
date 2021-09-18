class Event < ApplicationRecord
  serialize :data

  after_initialize do
    self.data ||= {}
  end

  def data
    JSON.parse(super || '{}')
  end

  def raw_data
    read_attribute :data
  end
end
