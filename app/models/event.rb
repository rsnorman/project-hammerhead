class Event < ApplicationRecord
  serialize :data

  after_initialize do
    self.data ||= {}
  end
end
