class Article < ApplicationRecord

  # Associations
  has_one :analytic

  # Callbacks
  before_save :normalize_title

  scope :filter_by_title,
  ->(query) { where("title ILIKE ?", "%#{query}%") }

  def normalize_title
    title.downcase!
  end

end
