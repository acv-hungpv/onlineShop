require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let!(:payment_list) { create_list(:payment, 3) } 
  let!(:item_list) { create_list(:item, 3, 
                                  payment: payment_list.first, 
                                  ispayment: true) }
  let!(:item_list_second) { create_list(:item, 3, 
                                        product: create(:product), 
                                        payment: payment_list.second, ispayment: true) }
  let!(:item_list_third) { create_list(:item, 3, 
                                        product: create(:product), 
                                        payment: payment_list.last, ispayment: true) }

  describe 'get #index' do 
    it 'get a list payment' do 
      get :index
      expect(assigns(:payments)).to eq payment_list.reverse
    end
  end

  describe "get #show" do
    it "assigns the requested product to @product" do
      get :show, params: { id: payment_list.first.id }
      assigns(:payment).should eq(payment_list.first)
    end

    it "renders the #show view" do
      get :show, params: { id: payment_list.first.id }
      response.should render_template :show
    end
  end

  describe "Post #is_items_to_payment" do 
    let!(:items_payment) { create_list(:item, 3) } 

    it 'rerender if does not select items to payment' do
      post :is_items_to_payment, params: { items_payment_id: nil }
      response.should redirect_to select_item_to_payment_path
    end

    it 'redirect to new payment if selected items to payment' do 
      post :is_items_to_payment, params: { items_payment_id: [items_payment.first.id,
                                                              items_payment.second.id,
                                                              items_payment.last.id] }
      response.should redirect_to new_payment_path
    end
  end

  describe "Post #create" do 
    let!(:items_payment) { create_list(:item, 3) } 

    it 'Valid post info ship and create payment' do 
      session[:items_payment_id] = [items_payment.first.id, 
                                  items_payment.second.id,
                                  items_payment.last.id]
      post :create, params: { payment: { name_ship: "Hung Phan", 
                                          address_ship: "HCM", 
                                          phone_ship: "01683853169"} }
      redirect_url = assigns(:payment_paypal).links.find { |link| link.rel == 'approval_url' }
      response.should redirect_to redirect_url.href
    end

    it 'Invalid post info ship and rerender' do 
      post :create, params: { payment: { name_ship: "Hung Phan", 
                                          address_ship: "HCM", 
                                          phone_ship: "wrong number"} }
      response.should render_template :new
    end
  end
end