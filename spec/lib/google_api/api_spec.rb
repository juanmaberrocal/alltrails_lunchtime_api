# frozen_string_literal: true

require 'rails_helper'

require 'google_api/api'

RSpec.describe GoogleApi::Api do
  let(:api) { described_class.new(api_key: api_key) }
  let(:api_key) { 'api-key' }

  describe '#find_place_request' do
    subject { api.find_place_request(input, fields: fields, input_type: input_type) }

    let(:fields) { 'field_1,field_2' }
    let(:input) { 'input-text' }
    let(:input_type) { 'input-type' }
    let(:request_klass) { instance_double(MapsApi::FindPlace, perform: true) }

    before do
      allow(MapsApi::FindPlace).to receive(:new)
        .with(api_key: api_key,
              fields: fields,
              input: input,
              input_type: input_type)
        .and_return(request_klass)

      subject
    end

    it 'instantiates and calls perform on request class' do
      expect(request_klass).to have_received(:perform)
    end
  end

  describe '#text_search_request' do
    subject { api.text_search_request(query, page_token: page_token, type: type) }

    let(:page_token) { 'page-token' }
    let(:query) { 'query-text' }
    let(:request_klass) { instance_double(MapsApi::TextSearch, perform: true) }
    let(:type) { 'query-type' }

    before do
      allow(MapsApi::TextSearch).to receive(:new)
        .with(api_key: api_key,
              page_token: page_token,
              query: query,
              type: type)
        .and_return(request_klass)

      subject
    end

    it 'instantiates and calls perform on request class' do
      expect(request_klass).to have_received(:perform)
    end
  end
end
