class Docs::Studio < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Studio do
    key :required, [:name]

    property :name do
      key :type, :string
      key :description, 'Studio Name'
    end

    property :stays do
      property :start_date do
        key :type, :string
        key :format, :date
        key :description, 'Stay start date'
      end

      property :end_date do
        key :type, :string
        key :format, :date
        key :description, 'Absence end date'
      end
    end
  end
end