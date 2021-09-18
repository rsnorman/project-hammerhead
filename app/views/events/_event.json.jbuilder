json.extract! event, :id, :name, :data, :created_at, :updated_at
json.url event_url(event, format: :json)
