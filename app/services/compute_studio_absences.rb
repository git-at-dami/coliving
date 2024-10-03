class ComputeStudioAbsences
  def self.call(studio)
    resulting_absences = []

    return resulting_absences if studio.stays.blank?

    stays = studio.stays.order(:start_date)
    last_end_date = Studio::RESIDENCE_OPENING_DATE

    stays.each do |stay|
      if stay.start_date > last_end_date
        resulting_absences << { start_date: last_end_date, end_date: stay.start_date - 1 }
      end

      last_end_date = stay.end_date + 1
    end

    # Check for absence after the last stay
    return resulting_absences unless last_end_date < Date.today

    resulting_absences << { start_date: last_end_date, end_date: Date.today }
  end
end