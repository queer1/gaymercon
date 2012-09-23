class GroupPostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_group
  before_filter :find_post, except: [:index, :new, :create]
  before_filter :authenticate_post, except: [:index, :new, :create]
  
  def index
    @posts = @group.posts.page(params[:page])
  end
  
  def show
    @comment = GroupComment.new(group_post: @post)
  end
  
  def new
    @post = GroupPost.new(group: @group)
  end
  
  def create
    parms = params[:group_post].slice(:kind, :title, :content, :image, :start_time, :end_time)
    parms[:user_id] = current_user.id
    parms[:group_id] = @group.id
    @post = GroupPost.create(parms)
    if @post.valid?
      redirect_to group_post_path(@group, @post), notice: "Post created!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@post.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:group_post].slice(:kind, :title, :content, :image, :start_time, :end_time)
    @post.update_attributes(parms)
    if @post.valid?
      redirect_to group_post_path(@group, @post), notice: "Post saved!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@post.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to group_path(@group), notice: "Post deleted"
  end
  
  private
    def find_group
      @group = Group.find params[:group_id]
      redirect_to groups_path, alert: "Sorry, couldn't find that group" unless @group.present?
    end
    
    def find_post
      @post = @group.posts.find(params[:id])
      redirect_to group_path(@group), alert: "Sorry, couldn't find that post" unless @post.present?
    end
    
    def authenticate_post
      redirect_to group_path(@group), alert: "Sorry, you don't have permission to do that" unless @post.editor?(current_user)
    end
  
end
