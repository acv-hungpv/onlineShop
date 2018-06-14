class CartsController < ApplicationController
  def addcart
    @product_id = (params[:product_id]).to_i
    @item = nil
    if current_user.present?
      item = find_item_in_addcart(@product_id)
      if (item == nil)
        item = current_user.items.build(product_id: @product_id, amounts: 1)
        item.save
        @item = item
      else
        item.amounts += 1
        item.save
        @item = item
      end
    else
      if session[:cart][@product_id].nil?
        session[:cart][@product_id] = 1
      else
        session[:cart][@product_id] = (session[:cart][@product_id]).to_i + 1
      end
    end
  end

  def carts

  end

  
  def changecart
    product_id = (params[:cart][:product_id]).to_i
    amounts = params[:cart][:amounts]
    if current_user.present?
      item = find_item_in_addcart(product_id)
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