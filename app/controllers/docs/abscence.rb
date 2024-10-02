class Docs::Abscence < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Abscence do
    key :required, [:name]

    property :name do
      key :type, :string
    end
  end

  swagger_schema :AbscenceInput do
    allOf do
      schema do
        key :'$ref', :Abscence
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