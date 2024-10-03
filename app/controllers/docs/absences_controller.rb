class Docs::AbsencesController < ActionController::Base
  include Swagger::Blocks

  swagger_path '/absences/' do
    operation :get do
      key :summary, 'List Absences by Studio'
      key :description, 'all the absences (dates between which the studio tenant is absent there) in the db'
      key :operationId, 'listAbsences'
      key :tags, [
        'absence'
      ]
     
      response 200 do
        key :description, 'Absences'
        schema do
          key :type, :array
          items do
            key :'$ref', :Absence
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
      key :description, 'Creates absences into Studios'
      key :operationId, 'addAbsences'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'absence'
      ]

      parameter do
        key :name, :absences
        key :in, :body
        key :description, 'absences to add into the studios'
        key :required, true
        schema do
          key :'$ref', :AbsenceInput
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