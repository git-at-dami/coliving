class Docs::AbscencesController < ActionController::Base
  include Swagger::Blocks

  swagger_path '/abscences/' do
    operation :get do
      key :summary, 'List Abscences by Studio'
      key :description, 'all the absences (dates between which the studio tenant is absent there) in the db'
      key :operationId, 'listAbscences'
      key :tags, [
        'abscence'
      ]
     
      response 200 do
        key :description, 'Abscences'
        schema do
          key :type, :array
          items do
            key :'$ref', :Abscence
          end
        end
      end

      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :Error
        end
      end
    end

    operation :post do
      key :description, 'Creates abscences into Studios'
      key :operationId, 'addAbscences'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'abscence'
      ]

      parameter do
        key :name, :abscences
        key :in, :body
        key :description, 'abscences to add into the studios'
        key :required, true
        schema do
          key :'$ref', :AbscenceInput
        end
      end

      response 200 do
        key :description, 'Studios'
        schema do
          key :type, :array
          items do
            key :'$ref', :Studio
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :Error
        end
      end
    end
  end
end