# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Absences", type: :request do
  let!(:studio1) { Studio.create(name: "Studio 1") }
  let!(:studio2) { Studio.create(name: "Studio 2") }

  describe "GET /index" do
    before do
      studio1.stays.create(start_date: '2024-01-05', end_date: '2024-01-10')
      studio2.stays.create(start_date: '2024-01-15', end_date: '2024-01-20')
      get '/absences'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns paginated studios with stays and absences" do
      json_response = JSON.parse(response.body)
      expect(json_response['studios'].size).to be 2

      studio1_data = json_response['studios'].find { |s| s['name'] == 'Studio 1' }
      expect(studio1_data['name']).to eq('Studio 1')
      expect(studio1_data['stays'].size).to eq(1)
      expect(studio1_data['stays'].first['start_date']).to eq('2024-01-05')
      expect(studio1_data['stays'].first['end_date']).to eq('2024-01-10')
      expect(studio1_data['absences']).to eq([
        { 'start_date' => '2024-01-01', 'end_date' => '2024-01-04' },
        { 'start_date' => '2024-01-11', 'end_date' => '2024-10-03' }
      ])

      studio2_data = json_response['studios'].find { |s| s['name'] == 'Studio 2' }
      expect(studio2_data['name']).to eq('Studio 2')
      expect(studio2_data['stays'].size).to eq(1)
      expect(studio2_data['stays'].first['start_date']).to eq('2024-01-15')
      expect(studio2_data['stays'].first['end_date']).to eq('2024-01-20')
      expect(studio2_data['absences']).to eq([
        { 'start_date' => '2024-01-01', 'end_date' => '2024-01-14' },
        { 'start_date' => '2024-01-21', 'end_date' => '2024-10-03' }
      ])
    end

    it "includes pagination metadata" do
      json_response = JSON.parse(response.body)
      expect(json_response['pagy']['count']).to eq(2)
      expect(json_response['pagy']['page']).to eq(1)
      expect(json_response['pagy']['pages']).to eq(1)
      expect(json_response['pagy']['prev']).to be_nil 
      expect(json_response['pagy']['next']).to be_nil 
    end
  end

  describe "POST /create" do
    context "with valid params" do
      let(:valid_params) do
        {
          absences: [
            { studio: "Studio 1", start_date: "2024-01-07", end_date: "2024-01-18" },
            { studio: "Studio 2", start_date: "2024-01-16", end_date: "2024-01-18" }
          ]
        }
      end

      before do
        studio1.stays.create(start_date: '2024-01-05', end_date: '2024-01-20')
        studio2.stays.create(start_date: '2024-01-15', end_date: '2024-01-20')
        post '/absences', params: valid_params
      end

      it "returns http created" do
        expect(response).to have_http_status(:created)
      end

      it "updates stays in the database" do
        expect(studio1.stays.pluck(:start_date, :end_date)).to eq([
          [Date.new(2024, 1, 5), Date.new(2024, 1, 6)],
          [Date.new(2024, 1, 19), Date.new(2024, 1, 20)]
        ])
        expect(studio2.stays.pluck(:start_date, :end_date)).to eq([
          [Date.new(2024, 1, 15), Date.new(2024, 1, 15)],
          [Date.new(2024, 1, 19), Date.new(2024, 1, 20)]
        ])
      end

      it "returns a success message" do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Stays updated successfully')
      end

      it "returns the updated studios with their stays" do
        json_response = JSON.parse(response.body)
        expect(json_response['studios'].size).to eq(2)

        updated_studio1 = json_response['studios'].find { |s| s['name'] == 'Studio 1' }
        expect(updated_studio1['stays'].size).to eq(2)
        expect(updated_studio1['stays'].first['start_date']).to eq('2024-01-05')
        expect(updated_studio1['stays'].first['end_date']).to eq('2024-01-06')
        expect(updated_studio1['stays'].last['start_date']).to eq('2024-01-19')
        expect(updated_studio1['stays'].last['end_date']).to eq('2024-01-20')

        updated_studio2 = json_response['studios'].find { |s| s['name'] == 'Studio 2' }
        expect(updated_studio2['stays'].size).to eq(2)
        expect(updated_studio2['stays'].first['start_date']).to eq('2024-01-15')
        expect(updated_studio2['stays'].first['end_date']).to eq('2024-01-15')
        expect(updated_studio2['stays'].last['start_date']).to eq('2024-01-19')
        expect(updated_studio2['stays'].last['end_date']).to eq('2024-01-20')
      end
    end

    context "with invalid params" do
      it "returns http unprocessable entity with invalid format" do
        post '/absences', params: { absences: "invalid" }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Invalid absences format')
      end

      it "returns http unprocessable entity with missing studio" do
        post '/absences', params: { absences: [{ studio: "Studio 3", start_date: "2024-01-07", end_date: "2024-01-18" }] }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Studio 'Studio 3' not found")
      end
    end
  end
end
