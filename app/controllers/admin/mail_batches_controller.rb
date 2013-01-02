class Admin::MailBatchesController < AdminController
  
  before_filter :find_batch, only: [:edit, :update, :transmit, :clear_unsent]
  before_filter do @section_name = "Mass Mail" end
  
  def index
    @batches = MailBatch.all
  end
  
  def show
    @record = MailBatchRecord.find_by_id(params[:id])
    redirect_to admin_mail_batches_path, alert: "Sorry, couldn't find that record" unless @record.present?
    @batch = @record.mail_batch
    @draft = @record.mail_batch_draft || @batch.latest_draft
  end
  
  def new
    @batch = MailBatch.new
  end
  
  def create
    @batch = MailBatch.new(name: params[:mail_batch][:name], user_id: current_user.id)
    if @batch.save
      flash[:notice] = "New batch created!"
      redirect_to edit_admin_mail_batch_path(@batch)
    else
      flash.now[:alert] = "Oops, there was a problem: #{@batch.all_errors}"
      render :new
    end
  end
  
  def edit
    @draft = @batch.drafts.order("created_at desc").first
    @draft ||= @batch.drafts.build
  end
  
  def update
    errors = []
    errors << "Problem with your mail batch: #{@batch.all_errors}" unless @batch.update_attributes(name: params[:mail_batch][:name])
    @draft = @batch.drafts.order("created_at desc").first
    if @draft.nil? || [:subject, :body].any?{|a| @draft.send(a) != params[:mail_batch_draft][a] }
      @draft = @batch.drafts.build(params[:mail_batch_draft])
      errors << "Problem with your draft: #{@draft.all_errors}" unless @draft.save
    end
    
    if @draft.present? && params[:csv].present?
      csv = params[:csv][:file]
      mbu = MailBatchUpload.new(csv.tempfile)
      failures = 0
      mbu.each do |record|
        record = MailBatchRecord.new(mail_batch_id: @batch.id, email: record[:email], info: record)
        unless record.save
          failures += 1
          errors << record.all_errors
        end
      end
      errors << "#{failures} records did not save correctly" if failures > 0
    end
    
    flash[:alert] = errors.uniq.join("\n") if errors.present?
    flash[:notice] = "Updates saved!" unless errors.present?
    redirect_to edit_admin_mail_batch_path(@batch)
  end
  
  def destroy
    @record = MailBatchRecord.find_by_id(params[:id])
    redirect_to admin_mail_batches_path, alert: "Sorry, couldn't find that record" unless @record.present?
    @record.destroy
    redirect_to edit_admin_mail_batch_path(@record.mail_batch), notice: "Record deleted"
  end
  
  def transmit
    ::ActiveRecord::Base.clear_all_connections!
    pid = fork do
      ::ActiveRecord::Base.establish_connection
      @batch.records.where(sent_at: nil).find_each do |record|
        record.transmit
      end
    end
    Process.detach pid
    ::ActiveRecord::Base.establish_connection
    redirect_to edit_admin_mail_batch_path(@batch), notice: "Sending emails now - refresh this page to check progress"
  end
  
  def clear_unsent
    @batch.records.where(sent_at: nil).destroy_all
    redirect_to edit_admin_mail_batch_path(@batch), notice: "Unsent emails cleared"
  end
  
  private
    def find_batch
      @batch = MailBatch.find_by_id(params[:id])
      @batch ||= MailBatch.find_by_id(params[:mail_batch_id])
      redirect_to admin_mail_batches_path, alert: "Sorry, couldn't find that batch" unless @batch.present?
    end
end
