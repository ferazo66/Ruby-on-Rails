class ArticlesController < ApplicationController
  def index
    @article=Article.all
  end
  def show
    @article=Article.find(params[:id])
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
    @article=Article.find(params[:id])
  end
  def update
    @article=Article.find(params[:id])
    if@article.update(article_params)
      redirect_to @article
    else
      render :'articles/edit'
    end
  end
  def destroy
    @article=Article.find(params[:id])
    @article.destroy
    redirect_to articles_index_path
  end
  private
  def article_params
    params.require(:article).permit(:title,:body)
  end
end
