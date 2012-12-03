class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @messages = Message.where("to_user_id = ?", current_user.id).order("created_at desc").page(params[:page])
  end
  
  def outbox
    @messages = Message.where("from_user_id = ?", current_user.id).order("created_at desc").page(params[:page])
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
      redirect_to outbox_messages_path
    else
      flash.now[:error] = "There was a problem: #{@message.errors.full_messages.join("<br />")}"
      render :new
    end
  end
  
  def edit
    @message = current_user.sent_messages.find_by_id(params[:id])
    redirect_to outbox_messages_path, alert: "Sorry, couldn't find that message" and return unless @message.present?
  end
  
  def update
    @message = current_user.sent_messages.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that message" and return unless @message.present?
    @message.update_attributes(content: params[:message][:content])
    if @message.persisted?
      flash[:notice] = "Message updated!"
      redirect_to outbox_messages_path
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
    @user_message = Message.find_by_id(params[:id])
    redirect_to messages_path, alert: "Sorry, couldn't find that message" and return unless @user_message.to_user == current_user || @user_message.from_user == current_user
    @user_message.update_attributes(read: true)
    @message = Message.new(to_user_id: @user_message.from_user_id)
  end
end
