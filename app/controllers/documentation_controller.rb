# frozen_string_literal: true

class DocumentationController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Coliving'
      key :description, 'Coliving Absences'
    end
    tag do
      key :name, 'studio'
      key :description, 'Studios operations'
    end
    key :host, 'coliving.colonies.com'
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  SWAGGERED_CLASSES = [
    Docs::AbsencesController,
    Docs::Studio,
    Docs::Absence,
    Docs::Error,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
