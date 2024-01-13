require 'fuzzystringmatch'

class Search < ApplicationRecord
  belongs_to :user

  validates :query, presence: true

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

    last_search.query.length < query.length
  end

  def self.similar?(text1, text2)
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    distance = jarow.getDistance(text1.gsub(/\s+/, ''), text2.gsub(/\s+/, ''))
    distance > 0.8
  end

end
