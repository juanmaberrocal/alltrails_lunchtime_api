# frozen_string_literal: true

require 'rails_helper'

require 'google_api/api'

RSpec.describe GoogleServices::RestaurantsSearch do
  # Constants
  let(:text_search_next_page_token) { 'next-page-token' }
  let(:text_search_results) { [{ 'key' => 'value' }] }
  let(:text_search_api) do
    instance_double(
      GoogleApi::MapsApi::TextSearch,
      results: text_search_results,
      next_page_token: text_search_next_page_token
    )
  end
  let(:google_api) { instance_double(GoogleApi::Api, text_search_request: text_search_api) }
  let(:query) { 'query' }
  let(:page_token) { 'page-token' }
  let(:service) { described_class.new(page_token: page_token, query: query) }

  before do
    allow(GoogleApi::Api).to receive(:new).and_return(google_api)
  end

  describe 'QUERY_TYPE' do
    subject { described_class::QUERY_TYPE }

    it { is_expected.to eq('restaurant') }
  end

  describe '#search' do
    subject { service.search }

    it 'calls text_search Google API request' do
      subject
      expect(google_api)
        .to have_received(:text_search_request)
        .with(query, page_token: page_token, type: described_class::QUERY_TYPE)
    end

    it 'returns touple of results and next_page_token' do
      expect(subject).to eq([text_search_results, text_search_next_page_token])
    end

    context 'when a TextSearchError is raised' do
      before do
        allow(google_api).to receive(:text_search_request).and_raise(GoogleApi::MapsApi::Errors::TextSearchError)
      end

      it 'rescues exception and an empty touple is returned' do
        expect(subject).to eq([])
      end
    end

    context 'when a RequestError is raised' do
      before do
        allow(google_api).to receive(:text_search_request).and_raise(GoogleApi::Errors::RequestError)
      end

      it 'rescues exception and an empty touple is returned' do
        expect(subject).to eq([])
      end
    end

    context 'when an Exception is raised' do
      before do
        allow(google_api).to receive(:text_search_request).and_raise(StandardError)
      end

      it 'rescues exception and an empty touple is returned' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe '#search!' do
    subject { service.search! }

    it 'passes request down to #search method' do
      expect(subject).to eq(service.search)
    end

    context 'when search result is empty' do
      subject { service.search! }

      before do
        allow(service).to receive(:search).and_return([])
      end

      it 'raises a RestaurantsSearchError' do
        expect { subject }.to raise_error(RestaurantsSearchError)
      end
    end
  end
end
