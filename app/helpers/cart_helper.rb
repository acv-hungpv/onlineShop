module CartHelper
  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def is_item_to_show_content_in_cart?
    return current_user.items.pluck(:ispayment).count(false) > 0
  end

  def find_product(product_id)
    return Product.find(product_id)
  end
end
