require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let!(:product) { create(:product) }

  context "Does not login" do 
    describe 'get list cart' do 
      it 'render cart view' do 
        get :cart
        response.should render_template :cart
      end
    end

    describe '#addcart' do 
      it 'addcart' do 
        session[:cart] = {}
        post :addcart, params: { product_id: product.id }
        expect(session[:cart][product.id.to_s]).to eq (1)
      end
    end

    describe '#change' do 
      it 'should change amouts item in cart' do
        session[:cart] = {}
        session[:cart][product.id.to_s] = 5
        post :changecart, params: { cart: { amounts: 20, 
                                            product_id: product.id } }
        expect(session[:cart][product.id.to_s]).to eq (20)
      end
    end

    describe '#delete' do 
      it 'should delete item in cart' do 
        session[:cart] = {}
        session[:cart][product.id.to_s] = 5
        expect {
          delete :deletecart, params: { format: product.id }
        }.to change { session[:cart].count }.by(-1)
      end
    end 
  end
 
  context "Logined" do 
    let!(:user) { create(:user) }

    before :each do
      session[:user_id] = user.id
    end

    describe '#addcart' do
      it 'addcart which item not in cart' do 
        expect {
          post :addcart, params: { product_id: product.id }
        }.to change { Item.count }.by(1)
      end

      it 'addcart which item in cart' do 
        item_before = Item.create(amounts: 3, user: user, 
                                  product: product, ispayment: false)      
        post :addcart, params: { product_id: product.id }
        item_after_addcart = Item.find(item_before.id)
        expect(item_after_addcart.amounts).to eq(4)
      end
    end

    describe '#change' do 
      it 'should change amouts item in cart' do
        amounts_change = 20
        item_before = Item.create(amounts: 3, user: user, 
                                            product: product, ispayment: false) 
        post :changecart, params: { cart: { amounts: amounts_change, 
                                            item_id: item_before.id } }
        item_after_addcart = Item.find(item_before.id)
        expect(item_after_addcart.amounts).to eq (amounts_change)
      end
    end 

    describe '#delete' do 
      it 'should delete item in cart' do 
        item = Item.create(amounts: 3, user: user, product: product)
        expect {
          delete :deletecart, params: { format: item.id }
        }.to change { Item.count }.by(-1)
      end
    end
  end
end