class DashboardController < ApplicationController
  def index
    @recent_operations = Operation.includes(:category, :subcategory).limit(10)
    @total_credits = Operation.joins(:category).where(categories: { operation_type: "credit" }).sum(:amount)
    @total_debits = Operation.joins(:category).where(categories: { operation_type: "debit" }).sum(:amount)
    @solde = @total_credits - @total_debits
  end
end
