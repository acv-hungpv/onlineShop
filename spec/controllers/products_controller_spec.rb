require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe '#index' do 
    it 'get a list products' do 
      products = []
      products << Product.create(name: "test product", description:"description test", 
                  price: 10, image: "https://")
      products << Product.create(name: "test product", description:"description test", 
                  price: 10, image: "https://")
      products << Product.create(name: "test product", description:"description test", 
                  price: 10, image: "https://")
      get :index
      expect(assigns(:products)) ==  products
    end
  end
end