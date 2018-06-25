class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def index
    session[:cart] ||= {}
    @products = Product.paginate(page: params[:page], per_page: 15)
  end

  def show

  end

  def edit

  end

  def update
    return redirect_to products_url, notice: 'you have successfully update product' if @product.update(product_params)
    flash[:danger] = 'There is an error in your update product'
    render :edit
  end

  def destroy
    return redirect_to products_url, notice: 'you have successfully delete product' if @product.destroy
    flash[:danger] = 'There is an error in your delete product'
    render :new
  end 


  private

  def product_params
    params.require(:product).permit(:name, :description, :url, :price, :currency, :image)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end