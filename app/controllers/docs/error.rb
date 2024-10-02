class Docs::Error
  include Swagger::Blocks

  swagger_schema :Error do
    key :required, [:message]

    property :message do
      key :type, :string
    end
  end
end