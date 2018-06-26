require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create' do
    let!(:user) { create(:user) }
    
    context "Valid to login" do 
      it "should redirect to list product" do 
        post :create, params: { session: { email: user.email, password: user.password } }
        response.should redirect_to products_path
      end
    end
    
    context "Invalid to login" do 
      it "should render new" do 
        post :create, params: { session: { email: user.email, password: "wrongPassword" } }
        response.should render_template :new
      end
    end
  end
 
  describe '#destroy' do 
    it 'should redirect to root_path when logged out' do 
      user = create(:user)
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to eq (nil)
      response.should redirect_to root_path
    end
  end 

end