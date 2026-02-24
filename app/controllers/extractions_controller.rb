class ExtractionsController < ApplicationController
  def index
    @categories = Category.includes(:subcategories).order(:operation_type, :name)
    @years = Operation.unscoped.pluck(:payment_date).compact.map { |d| d.year.to_s }.uniq.sort.reverse
    @years = [Date.current.year.to_s] if @years.empty?
  end

  def results
    @year = params[:year]
    @months = (params[:months] || []).reject(&:blank?)
    @category_ids = (params[:category_ids] || []).reject(&:blank?)
    @subcategory_ids = (params[:subcategory_ids] || []).reject(&:blank?)

    year_start = Date.new(@year.to_i, 1, 1)
    year_end = Date.new(@year.to_i, 12, 31)

    @operations = Operation.unscoped.includes(:category, :subcategory)
                           .where(payment_date: year_start..year_end)

    if @months.any?
      month_ints = @months.map(&:to_i)
      @operations = @operations.where(extract_month_sql, *month_ints)
    end
    @operations = @operations.where(category_id: @category_ids) if @category_ids.any?
    @operations = @operations.where(subcategory_id: @subcategory_ids) if @subcategory_ids.any?

    @operations = @operations.order(payment_date: :asc)

    base = @operations.reorder(nil)

    @total_debits = base.joins(:category).where(categories: { operation_type: "debit" }).sum(:amount)
    @total_credits = base.joins(:category).where(categories: { operation_type: "credit" }).sum(:amount)
    @solde = @total_credits - @total_debits

    @totals_by_category = base.joins(:category)
                               .group("categories.name")
                               .sum(:amount)

    @totals_by_month = base.group(Arel.sql(extract_month_expr))
                            .sum(:amount)

    @categories = Category.includes(:subcategories).order(:operation_type, :name)
    @years = Operation.unscoped.pluck(:payment_date).compact.map { |d| d.year.to_s }.uniq.sort.reverse
    @years = [Date.current.year.to_s] if @years.empty?
  end

  private

  def sqlite?
    ActiveRecord::Base.connection.adapter_name.downcase.include?("sqlite")
  end

  def extract_month_expr
    if sqlite?
      "CAST(strftime('%m', payment_date) AS INTEGER)"
    else
      "EXTRACT(MONTH FROM payment_date)::integer"
    end
  end

  def extract_month_sql
    if sqlite?
      "CAST(strftime('%m', payment_date) AS INTEGER) IN (#{Array.new(@months.size, '?').join(', ')})"
    else
      "EXTRACT(MONTH FROM payment_date)::integer IN (#{Array.new(@months.size, '?').join(', ')})"
    end
  end
end
