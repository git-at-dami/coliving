class Docs::Absence < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Absence do
    key :required, [:name]

    property :name do
      key :type, :string
    end
  end

  swagger_schema :AbsenceInput do
    allOf do
      schema do
        key :'$ref', :Absence
      end
      schema do
        key :required, [:name]
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end
end