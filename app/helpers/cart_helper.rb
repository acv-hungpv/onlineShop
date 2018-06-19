module CartHelper
  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def find_product(product_id)
    return Product.find(product_id)
  end
end
