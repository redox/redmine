class CommentsController < ApplicationController
  default_search_scope :news
  model_object News
  before_filter :find_model_object, :except => :review
  before_filter :find_project_from_association, :except => :review
  before_filter :authorize, :except => :review

  verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = User.current
    if @news.comments << @comment
      flash[:notice] = l(:label_comment_added)
    end

    redirect_to :controller => 'news', :action => 'show', :id => @news
  end

  verify :method => :delete, :only => :destroy, :render => {:nothing => true, :status => :method_not_allowed }
  def destroy
    @news.comments.find(params[:comment_id]).destroy
    redirect_to :controller => 'news', :action => 'show', :id => @news
  end
  
  verify :method => :post, :only => :review, :render => {:nothing => true, :status => :method_not_allowed }
  def review
    comment = Review.new(params[:comment])
    comment.author = User.current
    activity = params[:type].constantize.find(params[:id])
    if activity.reviews << comment
      flash[:notice] = l(:label_comment_added)
    end
    redirect_to :back
  end

  private

  # ApplicationController's find_model_object sets it based on the controller
  # name so it needs to be overriden and set to @news instead
  def find_model_object
    super
    @news = @object
    @comment = nil
    @news
  end

end
