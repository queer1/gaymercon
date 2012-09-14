class ForumsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  
  def index
    if(current_user && params[:mark_all_read])
      current_user.last_sign_in_at = Time.now
      current_user.save
    end
    @threads = ForumThread.paginate(:page => params[:page])
  end
  
  def new
    @thread = ForumThread.new
  end
  
  def create
    redirect_to(new_forum_path, notice: "Sorry, you must enter a title") and return unless params[:title].present?
    redirect_to(new_forum_path, notice: "Sorry, you must enter a message") and return unless params[:message].present?
    @thread = ForumThread.where(title: params[:title], user_id: current_user.id).first_or_create
    @post = @thread.forum_posts.create(:user => current_user, :message => params[:message])
    
    redirect_to forum_path(@thread.id, notice: "Thread created!")
  end
  
  def show
    @thread = ForumThread.find_by_id(params[:id])
    redirect_to forums_path, alert: "Sorry, couldn't find that thread." and return unless @thread.present?
    if params[:page] == "latest"
      posts = @thread.forum_posts.page(1)
      params[:page] = posts.total_pages
    end
    @posts = @thread.forum_posts.paginate(:page => params[:page])
  end
end
