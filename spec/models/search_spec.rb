RSpec.describe Search, :type => :model do

  describe "Save search" do
    let (:user) { create(:user) }
    it "create a search query if not present" do
      expect {
        Search.save_search("hello", user)
      }.to change(user.searches, :count).by(1)
    end

    it "updates a search query if present" do
      search = create(:search, user_id: user.id)
      initial_query = search.query
      expect {
        Search.save_search("#{search.query}ab", user)
      }.to change(user.searches, :count).by(0)
      expect(search.reload.query).to eq "#{initial_query}ab"
    end
  end

  describe "Should Save search" do
    let (:user) { create(:user) }
    it "if query is blank" do
      search = create(:search, user_id: user.id)
      expect(Search.should_save_search?("", search)).to eq false
    end

    it "returns true if last search is nil" do
      expect(Search.should_save_search?("hello", nil)).to eq true
    end

    it "increments a search query count if its present" do
      search = create(:search, user_id: user.id)
      expect(Search.should_save_search?("#{search}kl", search)).to eq true
    end
  end

end