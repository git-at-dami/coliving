class AbsencesController < ApplicationController
  include Pagy::Backend

  def index
    pagy, studio_records = pagy(Studio.includes(:stays).all) 

    render json: { 
      studios: studio_records.map { |studio| { name: studio.name, stays: studio.stays, absences: studio.absences  } },
      pagy: pagy_metadata(pagy) 
    }
  end

  def create
    # TODO: Potential Improvements 
    # 1: Authentication for Updating Stays
    # 2: Better validation using dry_validation gem
    # 3: Creating Serializers for Responses

    absences = params[:absences]
    
    if absences.nil? || !absences.is_a?(Array)
      render json: { message: 'Invalid absences format' }, status: :unprocessable_entity
      return
    end

    absences.map do |absence|
      studio_name = absence[:studio]
      start_date = Date.parse(absence[:start_date])
      end_date = Date.parse(absence[:end_date])

      studio = Studio.find_by(name: studio_name)
      if studio.nil?
        render json: { message: "Studio '#{studio_name}' not found" }, status: :unprocessable_entity
        return
      end

      studio.update_stays_for_absence(start_date, end_date)
    end

    render json: { 
        message: 'Stays updated successfully',  
        studios: Studio.where(name: absences.map { |absence| absence[:studio] }).map do |studio|
          { 
            name: studio.name, 
            stays: studio.stays 
          }
        end
      }, 
      status: :created
  end
end
