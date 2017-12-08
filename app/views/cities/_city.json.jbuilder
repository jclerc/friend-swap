json.extract! city, :id, :name, :latitude, :longitude, :created_at, :updated_at
json.url city_url(city, format: :json)
