class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.includes(:subcategories).order(:operation_type, :name)
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Catégorie « #{@category.name} » créée avec succès."
    else
      @categories = Category.includes(:subcategories).order(:operation_type, :name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Catégorie « #{@category.name} » modifiée avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.operations.any?
      redirect_to categories_path, alert: "Impossible de supprimer la catégorie « #{@category.name} » : des opérations y sont rattachées."
    elsif @category.subcategories.any?
      redirect_to categories_path, alert: "Impossible de supprimer la catégorie « #{@category.name} » : des sous-catégories y sont rattachées."
    else
      @category.destroy
      redirect_to categories_path, notice: "Catégorie « #{@category.name} » supprimée avec succès."
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :operation_type)
  end
end
