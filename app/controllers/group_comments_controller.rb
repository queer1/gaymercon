class GroupCommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_group
  before_filter :find_post
  before_filter :find_comment, except: [:index, :new, :create]
  before_filter :authenticate_comment, only: [:edit, :update, :destroy]
  
  def index
    render "group_posts/show"
  end
  
  def create
    parms = {group_post_id: @post.id, user_id: current_user.id}.merge(params[:group_comment].slice(:content))
    @comment = GroupComment.create(parms)
    if @comment.valid?
      redirect_to group_post_path(@group.id, @post), notice: "Comment posted!"
    else
      flash.now[:alert] = "Oops, there was a problem"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @comment.update_attributes(params[:group_comment].slice(:content))
    if @comment.valid?
      redirect_to group_post_path(@group.id, @post), notice: "Comment updated!"
    else
      flash.now[:alert] = "Oops, there was a problem"
      render :edit
    end
  end
  
  def destroy
    @comment.destroy
    redirect_to group_post_path(@group.id, @post), notice: "Comment deleted."
  end
  
  private
    def find_group
      @group = Group.find_by_id(params[:group_id])
      @group ||= Group.find_by_url(params[:group_id])
      redirect_to groups_path, alert: "Sorry, couldn't find that group" unless @group.present?
    end
    
    def find_post
      @post = @group.posts.find_by_id(params[:post_id])
      redirect_to group_path(@group), alert: "Sorry, couldn't find that post" unless @post.present?
    end
    
    def find_comment
      @comment = @post.comments.find_by_id(params[:id])
      redirect_to group_post_path(@group.id, @post), alert: "Sorry, couldn't find that comment" unless @comment.present?
    end
    
    def authenticate_comment
      redirect_to group_post_path(@group.id, @post), alert: "Sorry, you don't have permission to do that" unless @comment.editor?(current_user)
    end
end
