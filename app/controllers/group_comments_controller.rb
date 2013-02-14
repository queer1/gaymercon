class GroupCommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_group
  before_filter :find_post
  before_filter :find_comment, except: [:index, :new, :create]
  before_filter :authenticate_comment, only: [:edit, :update, :destroy]
  
  def index
    redirect_to group_post_path(@group, @post.id) and return
  end
  
  def show
    @og_object = @comment
  end
  
  def new
    redirect_to Group.find_by_id(params[:group_id]) and return if params[:group_id].present?
    redirect_to group_post_path(@comment.group_post_id)
  end
  
  def create
    parms = {group_post_id: @post.id, user_id: current_user.id}.merge(params[:group_comment].slice(:content))
    @comment = GroupComment.create(parms)
    if @comment.valid?
      redirect_to group_post_path(@group, @post.id), notice: "Comment posted!"
    else
      flash.now[:alert] = "Oops, there was a problem"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @comment = GroupComment.find_by_id(params[:comment_id]) if params[:comment_id].present?
    @post ||= @comment.post
    @group ||= @post.group
    
    @comment.update_attributes(params[:group_comment].slice(:content))
    if @comment.valid?
      redirect_to group_post_path(@group, @post.id), notice: "Comment updated!"
    else
      flash.now[:alert] = "Oops, there was a problem"
      render :edit
    end
  end
  
  def destroy
    @comment.destroy
    redirect_to group_post_path(@group, @post.id), notice: "Comment deleted."
  end
  
  def like
    redirect_to group_post_path(@group, @post), alert: "Can't reward your own post, silly!" and return if @comment.user == current_user
    @comment.like(current_user)
    render json: {message: "You 1UP'd #{@comment.user.try(:name) || 'this user'}'s post"} and return if request.xhr?
    redirect_to group_post_path(@group, @post), notice: "Granted 15xp!"
  end
  
  def unlike
    redirect_to group_post_path(@group, @post), alert: "Can't unreward your own post, silly!" and return if @comment.user == current_user
    @comment.unlike(current_user)
    render json: {message: "Un-up'd #{@comment.user.try(:name) || 'this user'}'s post"} and return if request.xhr?
    redirect_to group_post_path(@group, @post), notice: "Cancelled :("
  end
  
  private
    def find_group
      ga = GroupAlias.where(url: params[:group_id]).first
      redirect_to group_path(ga.group), notice: "This group has been merged into #{ga.group.name}" and return false if ga.present?
      @group = Group.find_by_id(params[:group_id])
      @group ||= Group.find_by_url(params[:group_id])
      render :action => "groups/private" and return unless @group.visible_to?(current_user)
      redirect_to groups_path, alert: "Sorry, couldn't find that group" unless @group.present?
      @section_name = @group.name
    end
    
    def find_post
      @post = @group.posts.find_by_id(params[:post_id])
      redirect_to group_path(@group), alert: "Sorry, couldn't find that post" unless @post.present?
    end
    
    def find_comment
      @comment = @post.comments.find_by_id(params[:id])
      redirect_to group_post_path(@group, @post.id), alert: "Sorry, couldn't find that comment" unless @comment.present?
    end
    
    def authenticate_comment
      redirect_to group_post_path(@group, @post.id), alert: "Sorry, you don't have permission to do that" unless @comment.editor?(current_user)
    end
end
