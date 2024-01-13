class ArticlesController < ApplicationController

  def index
    if params[:search].present?
      @articles = Article.filter_by_title(params[:search])
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

  private

  def articles_params
    params.require(:article).permit(:title, :body)
  end
end
