class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :set_article, except: [:index,:new,:create]
  before_action :authenticate_editor!,only: [:new,:create,:update]
  before_action :authenticate_admin!,only: [:destroy,:publish]
  def index
    @article=Article.paginate(page: params[:page],per_page:2).published
  end
  def show
    @article.update_visits_count
    @comment=Comment.new
  end
  def new
    @article=Article.new
    @categories =Category.all
  end
  def create
    @article=current_user.articles.new(article_params)
    @article.categories =params[:categories]
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
  def publish
    @article.publish!
    redirect_to @article
  end
  def destroy
    @article.destroy
    redirect_to root_path
  end
  private
  def article_params
    params.require(:article).permit(:title,:body,:cover,:categories)
  end
  def set_article
    @article=Article.find(params[:id])
  end
end
