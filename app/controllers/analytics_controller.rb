class AnalyticsController < ApplicationController
  def index
    @search_data = Article.includes(:analytic).group('articles.title').sum('analytics.no_of_searches')
    @view_data = Article.includes(:analytic).group('articles.title').sum('analytics.no_of_views')
  end
end