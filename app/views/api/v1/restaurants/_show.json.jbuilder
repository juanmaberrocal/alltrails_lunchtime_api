# frozen_string_literal: true

json.merge! restaurant.slice('formatted_address',
                             'geometry',
                             'name',
                             'photos',
                             'place_id')
