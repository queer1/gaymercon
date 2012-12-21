class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter do @section_name = "Messages" end
  
  def index
    @threads = MessageThread.all_for_user(current_user)
  end
  
  def new
    @to_user = User.find(params[:to_user_id])
    @message = Message.new(to_user_id: @to_user.id)
  end
  
  def create
    fields = params[:message].slice(:to_user_id, :content)
    fields[:from_user_id] = current_user.id
    @message = Message.create(fields)
    if @message.persisted?
      flash[:notice] = "Message sent!"
      redirect_to messages_path
    else
      flash.now[:error] = "There was a problem: #{@message.errors.full_messages.join("<br />")}"
      render :new
    end
  end
  
  def edit
    @message = current_user.sent_messages.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that message" and return unless @message.present?
  end
  
  def update
    @message = current_user.sent_messages.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that message" and return unless @message.present?
    @message.update_attributes(content: params[:message][:content])
    if @message.persisted?
      flash[:notice] = "Message updated!"
      redirect_to messages_path
    else
      flash.now[:error] = "There was a problem: #{@message.errors.full_messages.join("<br />")}"
      render :edit
    end
  end
  
  def destroy
    @message = Message.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that message" and return unless @message.present? && @message.from_user == current_user
    @message.destroy
    flash[:notice] = "Message destroyed!"
    redirect_to messages_path
  end
  
  def show
    @user = User.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that thread" and return unless @user.present?
    @thread = MessageThread.new(current_user, @user)
    @thread.messages.each do |m| 
      m.update_attributes(read: true) if m.to_user_id == current_user.id
    end
    @message = Message.new(to_user: @user, from_user: current_user)
  end
end
