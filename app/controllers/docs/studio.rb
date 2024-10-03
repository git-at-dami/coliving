class Absence < ActiveRecord::Base
    include Swagger::Blocks
  
    swagger_schema :Absence do
      key :required, [:name]
  
      property :name do
        key :type, :string
      end
    end
  
    swagger_schema :AbsenceInput do
      property :studio do
        key :type, :string
      end

      property :start_date do
        key :type, :date
      end

      property :end_date do
        key :type, :date
      end
    end
  end