class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :set_article, except: [:index,:new,:create]
  def index
    @article=Article.all
  end
  def show
    @article.update_visits_count
    @comment=Comment.new
  end
  def new
    @article=Article.new
  end
  def create
    @article=current_user.articles.new(article_params)
   if @article.save
    redirect_to @article
   else
     render :new
   end
  end
  def edit
  end
  def update
    if@article.update(article_params)
      redirect_to @article
    else
      render :'articles/edit'
    end
  end
  def destroy
    @article.destroy
    redirect_to articles_index_path
  end
  private
  def article_params
    params.require(:article).permit(:title,:body,:cover)
  end
  def set_article
    @article=Article.find(params[:id])
  end
end
