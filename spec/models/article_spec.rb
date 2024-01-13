require 'rails_helper'

RSpec.describe Article, :type => :model do

  let (:article) { create(:article) }
  it "downcases the title of the article" do
    expect(article.normalize_title).to eq article.title.downcase
  end

  it "update article views" do
    expect(article.analytic).to eq nil
    article.update_article_views
    expect(article.analytic.present?).to eq true
    expect(article.analytic.no_of_views).to eq 1
  end

end