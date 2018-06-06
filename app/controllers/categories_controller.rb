class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  def index
    @categories = Category.paginate(page: params[:page], per_page: 20)
  end

  def show 
    @products = @category.products.paginate(page: params[:page],per_page: 25)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end