class ExtractionsController < ApplicationController
  def index
    @categories = Category.includes(:subcategories).order(:operation_type, :name)
    @years = Operation.unscoped.distinct.pluck(Arel.sql("strftime('%Y', payment_date)")).compact.sort.reverse
    @years = [Date.current.year.to_s] if @years.empty?
  end

  def results
    @year = params[:year]
    @months = (params[:months] || []).reject(&:blank?)
    @category_ids = (params[:category_ids] || []).reject(&:blank?)
    @subcategory_ids = (params[:subcategory_ids] || []).reject(&:blank?)


    @operations = Operation.unscoped.includes(:category, :subcategory)
                           .where("strftime('%Y', payment_date) = ?", @year)

    @operations = @operations.where("CAST(strftime('%m', payment_date) AS INTEGER) IN (?)", @months.map(&:to_i)) if @months.any?
    @operations = @operations.where(category_id: @category_ids) if @category_ids.any?
    @operations = @operations.where(subcategory_id: @subcategory_ids) if @subcategory_ids.any?

    @operations = @operations.order(payment_date: :asc)

    @total_debits = @operations.joins(:category).where(categories: { operation_type: "debit" }).sum(:amount)
    @total_credits = @operations.joins(:category).where(categories: { operation_type: "credit" }).sum(:amount)
    @solde = @total_credits - @total_debits

    @totals_by_category = @operations.joins(:category)
                                      .group("categories.name")
                                      .sum(:amount)

    @totals_by_month = @operations.group(Arel.sql("CAST(strftime('%m', payment_date) AS INTEGER)"))
                                   .sum(:amount)

    @categories = Category.includes(:subcategories).order(:operation_type, :name)
    @years = Operation.unscoped.distinct.pluck(Arel.sql("strftime('%Y', payment_date)")).compact.sort.reverse
    @years = [Date.current.year.to_s] if @years.empty?
  end
end
