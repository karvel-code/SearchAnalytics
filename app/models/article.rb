class Article < ApplicationRecord

  # Associations
  has_one :analytic

  # Callbacks
  before_save :normalize_title

  scope :filter_by_title,
  ->(query) { where("title ILIKE ?", "%#{query}%") }

  def normalize_title
    title.downcase
  end

  def update_article_views
    if analytic.present?
      views = analytic&.no_of_views
      views = views += 1
      analytic.update(no_of_views: views)
    else
      create_analytic(no_of_views: 1)
    end
  end

end
