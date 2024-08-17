# frozen_string_literal: true

# CommonFilters
module CommonFilters
  extend ActiveSupport::Concern

  def filter_by_created_at
    return unless (fd = filter[:created_at])

    add_scope { |c| c.where(created_at: date_period(fd)) } if fd[:from] || fd[:to]
  end

  def filter_by_ids
    add_scope { |c| c.where(id: filter[:ids]) } unless filter[:ids].blank?
  end

  def filter_by_excluded_ids
    add_scope { |c| c.where.not(id: filter[:excluded_ids]) } unless filter[:excluded_ids].blank?
  end

  def filter_by_search; end

  private

  # Date.strptime('2020-12-12', '%y-%m-%d')
  def date_period(params)
    from = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : nil
    to = params[:to].present? ? Date.parse(params[:to]).end_of_day : nil
    from..to
  end
end
