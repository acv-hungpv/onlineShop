class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  
  def index
    @categories = Category.includes(:products).paginate(page: params[:page], per_page: 15)
  end

  def show 
    @products = @category.products.paginate(page: params[:page],per_page: 10)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end