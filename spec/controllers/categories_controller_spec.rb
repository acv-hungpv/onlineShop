require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe '#index' do 
    let!(:product_list) { create_list(:category, 3) }

    it 'get list categories' do 
      get :index
      expect(assigns(:categories)).to eq product_list.reverse
    end
  end

  describe "GET #show" do
    let!(:category) { create(:category) }
    
    it "should show detail a categry" do
      get :show, params: {id: category.id }
      assigns(:category).should eq(category)
    end

    it "renders the #show view" do
      get :show, params: { id: category.id }
      response.should render_template :show
    end
  end
end