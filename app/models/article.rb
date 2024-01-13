class Article < ApplicationRecord

  scope :filter_by_title,
  ->(query) { where("title ILIKE ?", "%#{query}%") }

end
