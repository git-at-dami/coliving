class Docs::Absence < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Absence do
    key :required, [:name]

    property :name do
      key :type, :string
      key :description, 'Studio Name'
    end

    property :start_date do
      key :type, :string
      key :format, :date
      key :description, 'Absence start date'
    end

    property :end_date do
      key :type, :string
      key :format, :date
      key :description, 'Absence end date'
    end
  end

  swagger_schema :AbsenceInput do
    allOf do
      schema do
        key :'$ref', :Absence
      end
      schema do
        key :required, [:name]

        property :name do
          key :type, :string
          key :description, 'Studio Name'
        end

        property :start_date do
          key :type, :string
          key :format, :date
          key :description, 'Absence start date'
        end

        property :end_date do
          key :type, :string
          key :format, :date
          key :description, 'Absence end date'
        end
      end
    end
  end
end