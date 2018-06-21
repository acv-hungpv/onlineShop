require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  context "does not login" do 
    describe 'get list cart' do 
      it 'render cart view' do 
        get :cart
        response.should render_template :cart
      end
    end

    describe '#addcart' do 
      it 'addcart' do 
        product = create(:product)
        session[:cart] = {}
        post :addcart, params: { product_id: product.id }
        expect(session[:cart][product.id.to_s]).to eq (1)
        post :addcart, params: { product_id: product.id }
        expect(session[:cart][product.id.to_s]).to eq (2)
      end
    end

    describe '#change' do 
      it 'should change amouts item in cart' do
        product = create(:product)
        session[:cart] = {}
        post :addcart, params: { product_id: product.id }
        post :changecart, params: { cart: { amounts: 20, product_id: product.id } }
        expect(session[:cart][product.id.to_s]).to eq (20)
      end
    end
  end
end