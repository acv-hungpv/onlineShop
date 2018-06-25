require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe '#index' do 
    let!(:product_list) { create_list(:product, 4) }

    it 'get a list products' do 
      get :index
      expect(assigns(:products)).to eq product_list.reverse
    end
  end

  describe "GET #show" do
    let!(:product) { create(:product) }

    it "assigns the requested product to @product" do
      get :show, params: { id: product.id }
      assigns(:product).should eq(product)
    end

    it "renders the #show view" do
      get :show, params: { id: product.id }
      response.should render_template :show
    end
  end

  describe "#edit " do 
    let!(:product) { create(:product) }

    it " render edit" do 
      get :edit, params: { id: product.id }
      expect(response).to render_template :edit
      expect(assigns(:product)).to eq product
    end
  end

  describe 'PUT update' do
    let!(:product) { create(:product) }

    params = { name: "update name", description: "desciption", 
                                      url: " http://goo", 
                                      price: 20, 
                                      currency: "$", 
                                      image: "https://google" }

    context "Valid attributes" do
      it "located the requested @product" do
        put :update,  params: { id: product.id, product: params }
        product.reload
        expect(product.name).to eq "update name"
        expect(product.price).to eq 20
      end

      it "redirects to the products list" do
        put :update,  params: { id: product.id, product: params }
        response.should redirect_to products_path
      end  
    end

    context "Invalid attributes" do
      it "doest not change product attributes" do 
        put :update,  params: { id: product.id, product: { name: "update name", 
                                                            description: nil } }
        product.reload
        expect(product.name).not_to eq "update name"
      end

      it "re-renders the edit method" do
        put :update,  params: { id: product.id, product: { name: "update name", 
                                                            description: nil } }
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @product = create(:product)
    end
    
    it "deletes the contact" do
      expect {
        delete :destroy, params: { id: @product.id }      
      }.to change(Product,:count).by(-1)
    end
      
    it "redirects to products#index" do
      delete :destroy, params: { id: @product.id }
      response.should redirect_to products_path
    end
  end
end