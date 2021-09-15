json.array! @restaurants do |restaurant|
  json.partial! 'api/v1/restaurants/show', restaurant: restaurant
end
