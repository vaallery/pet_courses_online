# frozen_string_literal: true

class BaseFilter
  prepend BasicCommand
  include CommonFilters

  option :collection
  option :filter
  option :order

  def call
    set_collection
    filter_collection if filter
    order_collection
    preload_association
  end

  def filter_collection
    filter_by_ids
    filter_by_excluded_ids
    filter_by_created_at
    filter_by_search
  end

  # def set_collection; end
  def preload_association; end

  def patch_order(key)
    "#{collection.table_name}.#{key}"
  end

  def order_collection
    return unless order&.any?

    orders = []
    order.each do |o|
      raise ArgumentError unless o[:direction].in?([ :asc, :desc, :ASC, :DESC, "asc", "desc", "ASC", "DESC" ])

      [ patch_order(o[:name]) ].flatten.each { |patch| orders << "#{patch} #{o[:direction]}" }
    end
    @collection = collection.order(Arel.sql(orders.join(",")))
  end

  def add_scope
    @collection = yield(collection)
  end

  private

  def set_collection
    @collection ||= /(.*)Filter/.match(self.class.name)[1].singularize.constantize
  end
end
