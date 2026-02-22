class OperationsController < ApplicationController
  before_action :set_operation, only: [:show, :edit, :update, :destroy]

  def index
    @operations = Operation.includes(:category, :subcategory).all
  end

  def show
  end

  def new
    @operation = Operation.new
    @categories = Category.all
    @subcategories = []
  end

  def create
    @operation = Operation.new(operation_params)
    if @operation.save
      redirect_to @operation, notice: "Opération créée avec succès."
    else
      @categories = Category.all
      @subcategories = @operation.category ? @operation.category.subcategories : []
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
    @subcategories = @operation.category.subcategories
  end

  def update
    if @operation.update(operation_params)
      redirect_to @operation, notice: "Opération modifiée avec succès."
    else
      @categories = Category.all
      @subcategories = @operation.category ? @operation.category.subcategories : []
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @operation.destroy
    redirect_to root_path, notice: "Opération supprimée avec succès."
  end

  private

  def set_operation
    @operation = Operation.find(params[:id])
  end

  def operation_params
    params.require(:operation).permit(:amount, :payment_date, :observation, :category_id, :subcategory_id)
  end
end
