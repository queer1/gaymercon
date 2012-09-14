class PostsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :setup_thread
  
  def index
    
  end
  
  
  def show
    @post = @thread.forum_posts.find_by_id(params[:id])
  end
  
  def create
    @post = @thread.forum_posts.create(:user => current_user, :message => params[:message])
    redirect_to(forum_path(@thread.id, :page => 'latest'))
  end
  
  def update
    @post = @thread.forum_posts.find_by_id(params[:id])
    unless @post.present? && current_user.mod? || @post.user == current_user
      redirect_to forum_path(@thread.id),notice: "Sorry, you don't have permission to do that" and return
    end
    @post.update_attributes(:message => params[:forum_post][:message])
    redirect_to forum_path(@thread.id), notice: "Your post has been edited!"
  end
  
  def destroy
    @post = @thread.forum_posts.find_by_id(params[:id])
    unless @post.present? && current_user.mod? || @post.user == current_user
      redirect_to forum_path(@thread.id),notice: "Sorry, you don't have permission to do that" and return
    end
    @post.destroy
    redirect_to forum_path(@thread.id), notice: "Your post has been deleted!"
  end
  
  private
    def setup_thread
      @thread = ForumThread.find_by_id(params[:forum_id])
      redirect_to(forums_path, error: "Sorry, couldn't find that thread.") and return unless @thread.present?
    end
end
