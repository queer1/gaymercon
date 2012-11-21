class Admin::DonatorsController < AdminController
  
  def index
    @donators = Donator.order("created_at desc").all
  end
  
  def show
    @donator = Donator.find_by_id(params[:id])
    redirect_to admin_donators_path, alert: "Sorry, couldn't find that donator" unless @donator.present?
  end
end
