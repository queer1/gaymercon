require 'fileutils'

class Admin::JobsController < AdminController
  before_filter :setup_job, :except => [:index, :new, :create]
  before_filter :upload_image, :only => [:create, :update]
  
  def index
    @jobs = Job.all
  end
  
  def show
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.create(params[:job])
    if @job.persisted?
      flash[:notice] = "Job created!"
      redirect_to edit_admin_job_path(@job)
    else
      flash.now[:error] = @job.errors.full_messages.join("<br />")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @job.update_attributes(params[:job])
    if @job.persisted?
      flash[:notice] = "Job updated!"
      redirect_to edit_admin_job_path(@job)
    else
      flash.now[:error] = @job.errors.full_messages.join("<br />")
      render :edit
    end
  end
  
  def delete
    @job.destroy
    redirect_to admin_jobs_path, notice: "job #{@job.name} deleted"
  end
  
  private
    def setup_job
      @job = Job.find_by_id(params[:id])
    end
    
    def upload_image
      return true unless params[:icon_file].present?
      img = Magick::Image.from_blob(params[:icon_file].read)
      if img.is_a?(Array)
        img_list = Magick::ImageList.new
        img.each do |i|
          i.resize_to_fit!(100, 100) if i.rows > 100 || i.columns > 100
          img_list << i 
        end
        img = img_list
      else
        img.resize_to_fit!(100, 100)
      end
      dir = File.join(Rails.root, "public", "system", "jobs")
      FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      if img.write(File.join(dir, params[:icon_file].original_filename))
        params[:job][:icon] = params[:icon_file].original_filename
      else
        flash.now[:error] = "There was an error uploading your image."
      end
    end
end
