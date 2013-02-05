class GroupPostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_group
  before_filter :find_post, except: [:index, :new, :create]
  before_filter :authenticate_post, except: [:index, :show, :new, :create, :like, :unlike]
  before_filter do @section_name = @group.name end
  
  def index
    @posts = @group.posts.page(params[:page])
  end
  
  def show
    Notification::ThreadNotification.clear(@post, current_user) if current_user.present?
    Notification::RewardNotification.clear(@post, current_user) if current_user.present?
    if @post.nsfw? && (current_user.nil? || !current_user.nsfw)
      render :action => "nsfw" and return
    end
    @page = params[:page] || "latest"
    @page = @post.comments.page(1).total_pages if @page == "latest"
    @comments = @post.comments.page(@page)
    @comment = GroupComment.new(group_post: @post)
  end
  
  def new
    @post = GroupPost.new(group: @group)
  end
  
  def create
    parms = params[:group_post]
    parms[:user_id] = current_user.id
    parms[:group_id] = @group.id
    @post = GroupPost.create(parms)
    if @post.valid?
      @post.place = params[:group_post][:place] if @post.kind == "location" || @post.kind == "event" && params[:group_post][:place].present?
      redirect_to group_post_path(@group, @post.id), notice: "Post created!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@post.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:group_post]
    parms[:user_id] = @post.user_id
    parms[:group_id] = @post.group_id
    @post.update_attributes(parms)
    if @post.valid?
      @post.place = params[:group_post][:place] if @post.kind == "location" && params[:group_post][:place].present?
      redirect_to group_post_path(@group, @post.id), notice: "Post saved!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@post.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to group_path(@group), notice: "Post deleted"
  end
  
  def like
    redirect_to group_post_path(@group, @post), alert: "Can't reward your own post, silly!" and return if @post.user == current_user
    @post.like(current_user)
    redirect_to group_post_path(@group, @post), notice: "Granted 15xp!"
  end
  
  def unlike
    redirect_to group_post_path(@group, @post), alert: "Can't unreward your own post, silly!" and return if @post.user == current_user
    @post.unlike(current_user)
    redirect_to group_post_path(@group, @post), notice: "Cancelled :("
  end
  
  private
    def find_group
      @group = Group.find_by_id params[:group_id]
      @group ||= Group.find_by_url params[:group_id]
      redirect_to groups_path, alert: "Sorry, couldn't find that group" and return unless @group.present?
      render :action => "groups/private" and return unless @group.visible_to?(current_user)
    end
    
    def find_post
      @post = @group.posts.find_by_id(params[:id])
      redirect_to group_path(@group), alert: "Sorry, couldn't find that post" unless @post.present?
    end
    
    def authenticate_post
      redirect_to group_path(@group), alert: "Sorry, you don't have permission to do that" unless @post.editor?(current_user)
    end
  
end
