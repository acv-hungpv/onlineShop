require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#create' do 
    user = { name: "hung", email: 'test@gmail.com', phone: '01683853169', address:'Ho Chi Minh',
              password: '123456', password_confirmation: '123456' }
    context "Valid User" do 
      it "should valid create user" do 
        expect{
          post :create, params: { user: user }
        }.to change(User, :count).by(1)
      end

      it "Redirects to the products list" do
        post :create, params: { user: user }
        response.should redirect_to products_path
      end        
    end

    context "Invalid User" do 
      it "Invalid create user" do 
        expect{
          post :create, params: { user: { name: "hung", email: ""} }
        }.to change(User, :count).by(0)
      end

      it "Invalid user render new" do
        post :create, params: { user: { name: "hung", email: "hung@gmail.com", password: "123" } }
        response.should render_template :new
      end        
    end
  end

  describe '#update' do 
    context "Valid User" do 
      let!(:user) { create(:user) }
      it "should valid update user" do 
        put :update, params: { id: user.id, user: { name:"HungHungupdate",
                                                    email: "testupdate@gmail.com",
                                                    address: user.address,
                                                    password: user.password,
                                                    password_confirmation: user.password_confirmation} }
        user.reload
        expect(user.name).to eq "HungHungupdate"
        expect(user.email).to eq "testupdate@gmail.com"
      end
    end

    context "Invalid User" do 
      let!(:user) { create(:user) }
      it "Invalid update user" do 
        put :update, params: { id: user.id, user: { email: nil } }
        response.should render_template :edit
      end
    end
  end

  describe '#edit' do
    let!(:user) { create(:user) }
    it "get edit" do 
      get :edit, params: { id: user.id }
      expect(response).to render_template :edit
      expect(assigns(:user)).to eq user
    end
  end
end