class Abscence < ActiveRecord::Base
    include Swagger::Blocks
  
    swagger_schema :Abscence do
      key :required, [:name]
  
      property :name do
        key :type, :string
      end
    end
  
    swagger_schema :AbscenceInput do
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