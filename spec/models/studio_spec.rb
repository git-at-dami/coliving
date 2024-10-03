# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Studio, type: :model do
  it 'validates presence of name' do
    studio = Studio.new(name: nil)
    expect(studio).to_not be_valid
  end

  it 'validates uniqueness of name' do
    Studio.create(name: 'My Studio')
    studio2 = Studio.new(name: 'My Studio')
    expect(studio2).to_not be_valid
  end

  describe '#abscences' do
    let(:studio) { Studio.create(name: 'Studio A') }

    it 'returns no absences if there are no stays' do
      expect(ComputeStudioAbscences.call(studio)).to be_empty
    end

    it 'returns an absence before the first stay' do
      studio.stays.create(studio: studio, start_date: '2024-01-10', end_date: '2024-01-15')
      expect(ComputeStudioAbscences.call(studio)).to eq([
        { start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 1, 9) },
        { start_date: Date.new(2024, 1, 16), end_date: Date.today }
      ])
    end

    it 'returns an absence after the last stay' do
      studio.stays.create(studio: studio, start_date: '2024-01-05', end_date: '2024-01-10')
      expect(ComputeStudioAbscences.call(studio)).to eq([
        { start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 1, 4) },
        { start_date: Date.new(2024, 1, 11), end_date: Date.today }
      ])
    end

    it 'returns absences between stays' do
      studio.stays.create(start_date: '2024-01-05', end_date: '2024-01-10')
      studio.stays.create(start_date: '2024-01-15', end_date: '2024-01-20')
      expect(ComputeStudioAbscences.call(studio)).to eq([
                                       { start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 1, 4) },
                                       { start_date: Date.new(2024, 1, 11), end_date: Date.new(2024, 1, 14) },
                                       { start_date: Date.new(2024, 1, 21), end_date: Date.today }
                                     ])
    end
  end

  describe '#update_stays_for_absence' do
    let(:studio) { Studio.create(name: 'Studio B') }

    it 'splits a stay that completely overlaps the absence' do
      stay = studio.stays.create(start_date: '2024-01-05', end_date: '2024-01-20')
      studio.update_stays_for_absence(Date.new(2024, 1, 10), Date.new(2024, 1, 15))
      expect(studio.stays.pluck(:start_date, :end_date)).to eq([
                                                                 [Date.new(2024, 1, 5), Date.new(2024, 1, 9)],
                                                                 [Date.new(2024, 1, 16), Date.new(2024, 1, 20)]
                                                               ])
      expect { stay.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates the end_date of a stay that starts before the absence' do
      stay = studio.stays.create(start_date: '2024-01-05', end_date: '2024-01-15')
      studio.update_stays_for_absence(Date.new(2024, 1, 10), Date.new(2024, 1, 20))
      expect(stay.reload.end_date).to eq(Date.new(2024, 1, 9))
    end

    it 'updates the start_date of a stay that ends after the absence' do
      stay = studio.stays.create(start_date: '2024-01-10', end_date: '2024-01-20')
      studio.update_stays_for_absence(Date.new(2024, 1, 5), Date.new(2024, 1, 15))
      expect(stay.reload.start_date).to eq(Date.new(2024, 1, 16))
    end

    it 'destroys a stay that falls entirely within the absence' do
      stay = studio.stays.create(start_date: '2024-01-10', end_date: '2024-01-15')
      studio.update_stays_for_absence(Date.new(2024, 1, 5), Date.new(2024, 1, 20))
      expect { stay.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
