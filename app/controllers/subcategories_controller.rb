class SubcategoriesController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.build(subcategory_params)
    if @subcategory.save
      redirect_to categories_path, notice: "Sous-catégorie « #{@subcategory.name} » créée avec succès."
    else
      redirect_to categories_path, alert: "Erreur : #{@subcategory.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.find(params[:id])
    if @subcategory.operations.any?
      redirect_to categories_path, alert: "Impossible de supprimer la sous-catégorie « #{@subcategory.name} » : des opérations y sont rattachées."
    else
      @subcategory.destroy
      redirect_to categories_path, notice: "Sous-catégorie « #{@subcategory.name} » supprimée avec succès."
    end
  end

  def for_category
    @subcategories = Subcategory.where(category_id: params[:category_id]).order(:name)
    render json: @subcategories.map { |s| { id: s.id, name: s.name } }
  end

  private

  def subcategory_params
    params.require(:subcategory).permit(:name)
  end
end
