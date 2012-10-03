class GroupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :forums]
  before_filter :find_group, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_filter :authenticate_owner, only: [:edit, :update, :destroy]
  
  def index
    if current_user.present?
      @coords = current_user.location.coords || Geoip.lookup(request.remote_ip)
      @nearby_groups = current_user.nearby_groups.to_a
      @your_groups = current_user.groups.order("updated_at desc").all
      @groups = Group.where("id NOT IN (?)", @your_groups.collect(&:id)).order("updated_at desc").page(params[:page])
    else
      @coords = Geoip.lookup(request.remote_ip)
      @nearby_groups = Group.nearby(@coords).all
      @your_groups = nil
      @groups = Group.order("updated_at desc").page(params[:page])
    end
  end
  
  def forums
    @groups = Group.forums
  end
  
  def show
    if @group.kind == "location"
      @nearby_users = @group.nearby_users
      @nearby_users = @nearby_users.where("id != ?", current_user.id) if current_user && @nearby_users.present?
      @nearby_users = @nearby_users.to_a.shuffle.take(10)
    end
    
    if @group.kind == "game"
      @game_groups = Group.where(game_key: @group.game_key).all - [@group]
    end
    
    @post_kind = params[:post_kind]
    @posts = @group.posts.where(kind: @post_kind).page(params[:page]) if @post_kind.present?
    @posts ||= @group.posts.page(params[:page])
  end
  
  def new
    @group = Group.new
  end
  
  def create
    parms = params[:group].slice(:name, :type, :description, :kind, :header, :site_name, :site_link, :game)
    parms[:moderator_id] = current_user.id
    @group = Group.create(parms)
    if @group.valid?
      current_user.groups << @group
      @group.place = params[:group][:place]
      redirect_to edit_group_path(@group), notice: "Group created!"
    else
      flash.now[:alert] = "Sorry, there was a problem: #{@group.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:group].slice(:name, :type, :description, :kind, :header, :site_name, :site_link, :game)
    @group.update_attributes(parms)
    if @group.valid?
      @group.place = params[:group][:place]
      redirect_to edit_group_path(@group), notice: "Group updated!"
    else
      flash.now[:alert] = "Sorry, there was a problem: #{@group.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @group.destroy
    redirect_to groups_path, notice: "Group deleted."
  end
  
  def join
    Membership.where(:user_id => current_user.id, :group_id => @group.id).first_or_create
    redirect_to group_path(@group), notice: "You've joined #{@group.name}!"
  end
  
  def leave
    Membership.where(:user_id => current_user.id, :group_id => @group.id).first.try(:destroy)
    redirect_to group_path(@group), notice: "You've left #{@group.name}."
  end
  
  private
    def find_group
      @group = Group.find_by_id(params[:id])
      redirect_to groups_path, alert: "Sorry, couldn't find that group" unless @group.present?
    end
    
    def authenticate_owner
      redirect_to groups_path, alert: "Sorry, you don't have permission to do that." unless @group.editor?(current_user)
    end
end
