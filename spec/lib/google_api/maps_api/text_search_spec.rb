# frozen_string_literal: true

require 'rails_helper'

require 'google_api/maps_api/text_search'

RSpec.describe GoogleApi::MapsApi::TextSearch do
  # Constants
  let(:type) { 'query-type' }
  let(:query) { 'query-text' }
  let(:page_token) { 'page-token' }
  let(:api_key) { 'api-key' }
  let(:request) do
    described_class.new(
      api_key: api_key,
      page_token: page_token,
      query: query,
      type: type
    )
  end

  describe 'URL' do
    subject { described_class::URL }

    it { is_expected.to eq('https://maps.googleapis.com/maps/api/place/textsearch/json') }
  end

  describe '#perform' do
    subject { request.perform }

    before do
      stub_request(:get, /#{described_class::URL}/).to_return(
        headers: { content_type: 'application/json' },
        body: response_body,
        status: response_status
      )
    end

    describe 'success response' do
      let(:response_body) do
        {
          results: response_body_results,
          next_page_token: response_body_next_page_token,
          status: response_body_status
        }.to_json
      end

      let(:response_body_results) do
        [
          { 'field' => 'response-1' },
          { 'field' => 'response-2' },
          { 'field' => 'response-3' }
        ]
      end

      let(:response_body_next_page_token) { 'next-page-token' }
      let(:response_body_status) { 'OK' }
      let(:response_status) { 200 }

      it 'sends get request to url' do
        subject
        expect(WebMock).to have_requested(:get, described_class::URL)
          .with(query: {
                  'key' => api_key,
                  'pagetoken' => page_token,
                  'query' => query,
                  'type' => type
                })
      end

      it 'sets the response results' do
        expect(subject.results).to eq(response_body_results)
      end

      it 'sets the response next_page_token' do
        expect(subject.next_page_token).to eq(response_body_next_page_token)
      end

      context 'when error status' do
        let(:response_body) do
          {
            error_message: response_body_error_message,
            status: response_body_status
          }.to_json
        end

        let(:response_body_error_message) { 'error-message' }
        let(:response_body_status) { 'Not-OK' }

        it 'raises an error' do
          expect { subject }.to raise_error(GoogleApi::MapsApi::Errors::TextSearchError, response_body_error_message)
        end
      end
    end

    describe 'fail response' do
      let(:response_body) { nil }
      let(:response_status) { 500 }

      it 'raises an error' do
        expect { subject }.to raise_error(GoogleApi::Errors::RequestError)
      end
    end
  end
end
