# frozen_string_literal: true

class Studio < ApplicationRecord
  RESIDENCE_OPENING_DATE = Date.new(2024, 1, 1)

  has_many :stays

  validates :name, presence: true, uniqueness: true

  def abscences
    resulting_absences = []

    stays = stays.order(:start_date)
    last_end_date = RESIDENCE_OPENING_DATE

    stays.each do |stay|
      if stay.start_date > last_end_date
        resulting_absences << { start_date: last_end_date, end_date: stay.start_date - 1 }
      end

      last_end_date = stay.end_date + 1
    end

    # Check for absence after the last stay
    return unless last_end_date < Date.today

    resulting_absences << { start_date: last_end_date, end_date: Date.today }
  end

  def update_stays_for_absence(start_date, end_date)
    stays.where('start_date < ?', end_date).where('end_date > ?', start_date).each do |stay|
      if stay.start_date < start_date && stay.end_date > end_date
        # Split the stay into two
        stays.create(start_date: stay.start_date, end_date: start_date - 1)
        stays.create(start_date: end_date + 1, end_date: stay.end_date)
        stay.destroy
      elsif stay.start_date < start_date
        stay.update(end_date: start_date - 1)
      elsif stay.end_date > end_date
        stay.update(start_date: end_date + 1)
      else
        stay.destroy
      end
    end
  end
end
