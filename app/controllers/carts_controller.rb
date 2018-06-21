class CartsController < ApplicationController
  include CartHelper
  def addcart
    @product = Product.find((params[:product_id]))
    if current_user.present?
      @item = Item.find_by(ispayment: false, product_id: @product.id, user_id: current_user.id)
      if (@item.blank?)
        @item =Item.new(product_id: @product.id, amounts: 1, user: current_user)
      else
        @item.amounts += 1
      end
      @item.save
    else
      if session[:cart][@product.id].blank?
        session[:cart][@product.id] = 1
      else
        session[:cart][@product.id] = (session[:cart][@product.id]).to_i + 1
      end
    end
  end

  def cart
    @items = Item.includes(:product).where(:user => current_user)
  end
  
  def changecart
    product_id = (params[:cart][:product_id]).to_i
    amounts = params[:cart][:amounts]
    if current_user.present?
      item = Item.find_by(ispayment: false, product_id: product_id, user_id: current_user.id)
      item.amounts = amounts
      item.save
    else
      session[:cart][product_id] = amounts
    end
    redirect_to cart_path
  end  

  def deletecart
    if current_user.present?
      item = Item.find(params['format'])
      return redirect_to cart_path, notice: 'you have successfully delete item' if item.destroy
      flash.now[:notice] = 'There is an error in your delete item'
      render :new
    else
      product_id = params['format']
      return redirect_to cart_path, notice: 'you have successfully delete item' if session[:cart].delete(product_id)
      flash.now[:notice] = 'There is an error in your delete item'
      render :new
    end

  end
end