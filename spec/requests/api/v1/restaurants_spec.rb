# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Restaurants', type: :request do
  describe 'POST /search' do
    subject { post '/search', headers: headers }

    let(:headers) { auth_headers }
    let(:restaurants_search_service) { instance_double(GoogleServices::RestaurantsSearch, search!: search_response) }

    let(:search_response) do
      [
        search_response_restaurants,
        search_response_next_page_token
      ]
    end

    let(:search_response_restaurants) do
      [
        {
          'formatted_address' => 'rest-formatted_address',
          'geometry' => 'rest-geometry',
          'name' => 'rest-name',
          'photos' => 'rest-photos',
          'place_id' => 'rest-place-id',
          'filtered_key' => 'rest-filtered_key'
        }
      ]
    end

    let(:search_response_next_page_token) { 'next-page-token' }

    before do
      allow(GoogleServices::RestaurantsSearch).to receive(:new).and_return(restaurants_search_service)
    end

    context 'when success response' do
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns restaurants search result as body' do
        subject
        expect(json_body).to match([
                                     {
                                       'formatted_address' => 'rest-formatted_address',
                                       'geometry' => 'rest-geometry',
                                       'name' => 'rest-name',
                                       'photos' => 'rest-photos',
                                       'place_id' => 'rest-place-id'
                                     }
                                   ])
      end

      it 'returns restaurants search next page token in headers' do
        subject
        expect(response_headers['X-Next-Page-Token']).to eq(search_response_next_page_token)
      end
    end

    context 'when error response' do
      before do
        allow(restaurants_search_service).to receive(:search!).and_raise(RestaurantsSearchError)
      end

      it 'returns http error' do
        subject
        expect(response).to have_http_status(:error)
      end

      it 'returns error json response' do
        subject
        expect(json_body).to eq(
          'message' => 'Something went wrong.',
          'status' => 'ERROR'
        )
      end
    end

    context 'when no token provided' do
      let(:headers) { {} }

      it 'returns http error' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error json response' do
        subject
        expect(json_body).to eq(
          'error' => 'Access token is missing in the request',
          'status' => 'error'
        )
      end
    end

    context 'when not authorized' do
      let(:headers) { { 'Authorization' => 'foo' } }

      it 'returns http error' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error json response' do
        subject
        expect(json_body).to eq(
          'error' => 'Invalid access token',
          'status' => 'error'
        )
      end
    end
  end
end
