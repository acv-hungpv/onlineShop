require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe '#index' do 
    it 'get list categories' do 
      categories = []
      categories << create(:category, name: "clothers")
      categories << create(:category, name: "glass")
      categories << create(:category, name: "cars") 
      get :index
      expect(assigns(:categories)).to eq categories.reverse
    end
  end

  describe "GET #show" do
    it "should show detail a categry" do
      category = create(:category)
      get :show, params: {id: category.id }
      assigns(:category).should eq(category)
    end
    it "renders the #show view" do
      get :show, params: {id: create(:category).id}
      response.should render_template :show
    end
  end
end