# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    def render_bad_request(message = "Некорретный запрос")
      render json: { errors: [ message ] },
             status: :bad_request
    end

    # Вернуть 400 - Bad Request, если параметры ошибочны
    rescue_from ActionController::ParameterMissing, ActiveRecord::StatementInvalid, ArgumentError do |e|
      Rails.logger.error e.to_s
      render json: { errors: [ e.message ] }, status: :bad_request
    end

    # Вернуть 400 - Bad Request, если параметры ошибочны
    rescue_from ActiveRecord::InvalidForeignKey do |e|
      Rails.logger.error e.to_s
      render json: { errors: [ "Невозможно изменить запись" ] },
             status: :bad_request
    end

    # Вернуть 401 - unauthorized, если учетная запись неавторизована
    rescue_from RailsJwtAuth::NotAuthorized, JWT::DecodeError do |_e|
      render json: { errors: [ "You are not authorized" ] }, status: :unauthorized
    end

    # Вернуть 403 - Forbidden
    rescue_from CanCan::AccessDenied, AccessDenied do |e|
      render json: { errors: [ e.message ] }, status: :forbidden
    end

    def render_not_found(message = "Запрашиваемая запись не найдена")
      render json: { errors: [ message ] },
             status: :not_found
    end

    # Вернуть 404 - Not Found, если запись в БД отсутствует
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: [ e.message ] }, status: :not_found
    end

    # 422 - Unprocessable Entity
    rescue_from ActiveRecord::RecordInvalid,
                ActiveRecord::NotNullViolation,
                JSON::Schema::ValidationError,
                FilterSortPagination::UnprocessableEntity,
                UnprocessableEntity do |e|
      source = e.try(:record)&.errors&.as_json || {}
      render json: { errors: [ e.message ], source: source }, status: :unprocessable_entity
    end
  end

  class UnprocessableEntity < StandardError; end

  class AccessDenied < StandardError; end
end
