class AnalyticsController < ApplicationController
  def index
    @search_data = Article.includes(:analytic).group('articles.title').sum('analytics.no_of_searches')
    @view_data = Article.includes(:analytic).group('articles.title').sum('analytics.no_of_views')
    @searched_terms = Search.order(no_of_times_searched: :desc)
  end
end