class Search < ApplicationRecord
  belongs_to :user

  validates :query, presence: true

  def self.save_search(query, user)
    last_search = user.searches.last
    if query.length >= 3 
      if last_search.present? && query.include?(last_search.query)
        last_search.update(query: query)
      else
        Search.create(query: query, user_id: user.id)
      end
    end
  end

end
