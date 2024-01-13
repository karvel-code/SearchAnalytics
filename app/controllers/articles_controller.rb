class ArticlesController < ApplicationController
  before_action :set_article, only: :show

  def index
    if params[:search].present?
      @articles = Article.filter_by_title(params[:search])
      Search.save_search(params[:search], current_user)
    else
      @articles  = Article.order("created_at DESC")
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(articles_params)
    
    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_path, notice: 'Article was Created Successfully!' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    # if @article.analytic.present?
      @article.update_article_views
    # end
  end

  private

  def articles_params
    params.require(:article).permit(:title, :body)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
