# frozen_string_literal: true

# Методы фильтрации сортировки и паджинации
module FilterSortPagination
  extend ActiveSupport::Concern
  DEFAULT_LIMIT = 100

  included do
    def filter_params
      {
        filter: filter,
        order: order
      }
    end

    def filter
      if params[:filter].present?
        filter = params[:filter].is_a?(String) ? JSON.parse(params[:filter]).with_indifferent_access : permitted_filter
      else
        filter = {}
        filter[:search] = params[:search] if params[:search]
      end
      filter
    end

    def add_filter_by_customer_id
      true
    end

    def permitted_filter
      params[:filter]&.permit!
    end

    def order
      if params[:order].present?
        order = if params[:order].is_a?(String)
                  JSON.parse(params[:order]).map(&:with_indifferent_access)
        else
                  params[:order].map do |o|
                    raise "#{o} - не является корректным объектом сортировки" unless o.is_a?(ActionController::Parameters)

                    o.permit!
                  end
        end
      else
        order = []
        order << { name: params[:sort], direction: (params[:direction] || :asc) } if params[:sort]
      end
      order = [] if order.blank?
      order << { name: "created_at", direction: "desc" } if order.detect { |o| o[:name] == "created_at" }.blank?
      order
    rescue StandardError => e
      raise UnprocessableEntity, "Ошибка в секции order: #{e.message}"
    end
  end

  def paginate(items)
    curr_page = params[:page] || params.dig(:pagination, :page) || params.dig(:pagination, :current_page) || 1
    limit = params[:limit] || params.dig(:pagination, :limit) || DEFAULT_LIMIT
    items.page(curr_page).per(limit)
  end

  def pagination_info(collection)
    {
      total_count: collection.total_count,
      total_pages: collection.total_pages,
      current_page: collection.current_page,
      limit: collection.limit_value,
      prev_page: collection.prev_page || 0,
      next_page: collection.next_page || 0,
      first_page: collection.first_page?,
      last_page: collection.last_page?,
      out_of_range: collection.out_of_range?
    }
  end

  class UnprocessableEntity < StandardError; end
end
