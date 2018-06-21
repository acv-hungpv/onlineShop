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
      expect(assigns(:products)).to eq products.reverse
    end
  end

  describe "GET #show" do
    it "assigns the requested product to @product" do
      product_show = create(:product)
      get :show, params: {id: product_show.id }
      assigns(:product).should eq(product_show)
    end
    it "renders the #show view" do
      get :show, params: {id: create(:product).id}
      response.should render_template :show
    end
  end

  describe "#edit " do 
    it " render edit" do 
      product = create(:product)
      get :edit, params: {id: product.id}
      expect(response).to render_template :edit
      expect(assigns(:product)).to eq product
    end
  end

  describe " #create success" do 
    let!(:product) { create(:product) }
    it "creates a new product" do
      post :create, { product: attributes_for(:product).merge(name: product.name, 
                                                              description: product.description, 
                                                              price: product.price, 
                                                              image: product.image) }
      expect(Product.count).to eq(1)
    end
  end
end