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
      if session[:cart][@product.id.to_s].blank?
        session[:cart][@product.id.to_s] = 1
      else
        session[:cart][@product.id.to_s] = (session[:cart][@product.id.to_s]).to_i + 1
      end
    end
  end

  def cart
    if current_user.present?
      @items = current_user.items.includes(:product)
    end
  end
  
  def changecart
    amounts = params[:cart][:amounts].to_i
    if current_user.present?
      item = Item.find(params[:cart][:item_id])
      item.amounts = amounts
      item.save
    else
      product_id = (params[:cart][:product_id])
      session[:cart][product_id.to_s] = amounts
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