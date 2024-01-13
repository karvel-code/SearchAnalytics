require 'fuzzystringmatch'

class Search < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :query, presence: true, uniqueness: true

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
    end
  end

  def self.should_save_search?(query, last_search)
    return false if query.blank? || query.length < 3
    return true if last_search.nil? || !query.include?(last_search.query)

    increment_search_count(query)
    update_article_analytics(query)
    last_search.query.length < query.length
  end

  def self.similar?(text1, text2)
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    distance = jarow.getDistance(text1.gsub(/\s+/, ''), text2.gsub(/\s+/, ''))
    distance > 0.8
  end

  def self.increment_search_count(query)
    search = Search.find_by(query: query)
    if search
      no_of_times_searched = search.no_of_times_searched
      no_of_times_searched = no_of_times_searched += 1
      search.update(no_of_times_searched: no_of_times_searched)
    end
  end

  def self.update_article_analytics(query)
    article = Article.find_by(title: query)
    if article.present?
      if article.analytic.present?
        article.analytic.increment!(:no_of_searches)
      else
        article.create_analytic(no_of_searches: 1)
      end
    end
  end

end
