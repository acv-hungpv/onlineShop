class CartsController < ApplicationController
  include CartHelper

  def addcart
    @product = Product.find((params[:product_id]))
    if current_user.present?
      @item = Item.find_by(ispayment: false, product_id: @product.id, user_id: current_user.id)
      return @item =Item.create(product_id: @product.id, amounts: 1, user: current_user) if (@item.blank?)
      @item.amounts += 1
      @item.save
    else
      return session[:cart][@product.id.to_s] = 1 if session[:cart][@product.id.to_s].blank?
      session[:cart][@product.id.to_s] += + 1
    end
  end

  def cart
    if session[:payment_id] != nil
      Payment.find(session[:payment_id]).destroy
      session[:payment_id] = nil
    end
    if current_user.present?
      @items = current_user.items.includes(:product)
    end
  end

  def select_item_to_payment
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