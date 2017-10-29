require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:ingredient) {create(:ingredient_with_recipes)}
  let(:user) { create(:user) }

  describe "ingredients/posts/index" do
    before(:each) { get :index, params: { ingredient_id: ingredient.id} }

    it "renders ingredients_posts template" do
      expect(response).to render_template(:index)
    end

    it "assigns an ingredient instance variable" do
      expect(assigns[:ingredient]).to eq(ingredient)
    end
  end

  describe "#location" do
    before(:each) { get :location, params: { ingredient_id: ingredient.id} }

    it "renders a location page" do
      expect(response).to render_template(:new_location)
    end
  end

  describe "create location" do
    describe "valid input" do
      let(:new_post) { {post_type: 'location', title: 'Wenistown', body: "444 Wenis Way"} }
      before(:each) do
        post :create, params: { ingredient_id: ingredient.id, post: new_post }, session: { user_id: user.id }
      end

      it "redirects to ingredient#show" do
        expect(response).to redirect_to(ingredient_path(ingredient))
      end

      it "creates a new location" do
        expect(Post.all.last.title).to eq("Wenistown")
      end

      it "Associates a new location with that ingredient" do
        expect(Ingredient.find(ingredient.id).locations.pluck(:title)).to include("Wenistown")
      end
    end

    describe "invalid input" do
      before(:each) do
        # Should fail uniqueness validator for title
        old_post = create(:location_with_ingredients)
        bad_post = {post_type: 'location', title: old_post.title, body: "444 Wenis Way"}
        post :create, params: { ingredient_id: ingredient.id, post: bad_post }, session: { user_id: user.id }
      end

      it "renders new location form" do
        expect(response).to render_template(:new_location)
      end

      it "populates an errors instance variable" do
        expect(assigns[:errors].length).to_not eq(0)
      end
    end
  end
end
