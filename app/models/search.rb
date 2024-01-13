require 'fuzzystringmatch'

class Search < ApplicationRecord
  # Relationships
  belongs_to :user

  # Validations
  validates :query, presence: true

  # Callbacks
  # before_create :check_and_update_existing_search
  # before_save :update_article_analytics


  # def self.save_search(query, user)
  #   last_search = user.searches.last
  #   if query.length >= 3 
  #     if last_search.present? && query.include?(last_search.query) || last_search.present? && last_search.query.include?(query)
  #       last_search.update(query: query)
  #     else
  #       Search.create(query: query, user_id: user.id)
  #     end
  #   end
  # end

  def self.save_search(query, user)
    last_search = user.searches.last
    return unless should_save_search?(query, last_search)

    if last_search.nil? || !similar?(last_search.query, query)
      Search.create(query:, user: user)
    else
      last_search.update(query:)
      increment_search_count(query)
    end
  end

  def self.should_save_search?(query, last_search)
    return false if query.blank? || query.length < 3
    return true if last_search.nil? || !query.include?(last_search.query)

    last_search.query.length < query.length
  end

  def self.similar?(text1, text2)
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    distance = jarow.getDistance(text1.gsub(/\s+/, ''), text2.gsub(/\s+/, ''))
    distance > 0.8
  end

  def increment_search_count(query)
    search = Search.find_by(query: query)
    if search
      search.update_columns(no_of_searches: + 1)
    else
      create(query: query, no_of_searches: 1)
    end
  end

  # def check_and_update_existing_search(query)
  #   existing_search = find_similar_search(query)
  #   if existing_search
  #     existing_search.increment!(:no_of_searches)
  #     throw(:abort)
  #   end
  # end

  # def find_similar_search(query)
  #   Search.find_by("query ILIKE ?", "%#{query}%")
  # end

  def update_article_analytics
    article = Article.find_by(title: search.query)
    if article.exists?
      if article.analytic.exists?
        article.analytic.increment!(:no_of_searches)
      else
        article.create_analytic(no_of_searches: 1)
      end
    end
  end

end
