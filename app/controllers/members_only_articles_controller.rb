class MembersOnlyArticlesController < ApplicationController
  before_action :authenticate_user, except:[:index,:show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  def index
    if user_signed_in?
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
    else
      render json: {error: 'Not authorized'}, status: :unauthorized
    end
  
  end

  def show
    if user_signed_in?
    article = Article.find(params[:id])
    render json: article
    else
      render json: {error:"Not authorized"}, status: :unauthorized
    end
  
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
def user_signed_in?
  session[:user_id].present?
end
end
