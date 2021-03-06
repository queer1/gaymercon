class Admin::BadgesController < AdminController
  
  before_filter :find_badge, only: [:show, :edit, :update, :destroy]
  
  def index
    @order = "created_at desc"
    @order = "level asc" if params[:order] == "level"
    @order = "price desc" if params[:order] == "price"
    @order = "code asc" if params[:order] == "code"
    
    if params[:q].present?
      q = params[:q]
      @badges = Badge.joins("left join users u on badges.user_id = u.id")
                     .joins("left join users p on badges.purchaser_id = p.id")
                     .joins("left join users a on badges.admin_id = a.id")
                     .where("code like '%#{q}%' or u.name like '%#{q}%' or u.email like '%#{q}%' or p.name like '%#{q}%' or p.email like '%#{q}%' or a.name like '%#{q}%' or a.email like '%#{q}%' or level = ? or price = ?", q.downcase.gsub(/\s+/, '_'), q.to_i * 100)
                     .order(@order)
                     .page(params[:page])
    end
    
    if params[:unredeemed_codes].present?
      @badges = Badge.where("code IS NOT NULL and code != '' and user_id IS NULL").order(@order).page(params[:page])
    end
    
    if params[:for_sale].present?
      @badges = Badge.where("price IS NOT NULL and price != '' and user_id IS NULL").order(@order).page(params[:page])
    end
    
    @badges ||= Badge.order(@order).page(params[:page])
    sales = Hash[StripePayment.connection.select_rows("SELECT DATE(created_at) as day, COALESCE(SUM(amount) / 100, 0) as sales FROM stripe_payments WHERE paid = 1 AND badge_id IS NOT NULL AND created_at > '#{(Time.now.beginning_of_day - 10.days).strftime('%Y-%m-%d')}' GROUP BY DATE(created_at)")]
    @chart = []
    0.upto(10) {|n| s = sales[Date.today - n.days].present? ? sales[Date.today - n.days] : 0; @chart << s; }
  end
  
  def show
  end
  
  def new
    @badge = Badge.new
  end
  
  def create
    parms = params[:badge]
    parms[:admin_id] = current_user.id
    if params[:redeem] == "purchase"
      parms[:code] = nil
      parms[:price] = (parms[:price].to_f * 100).to_i
    else
      parms[:price] = nil
    end
    @badge = Badge.create(parms)
    if @badge.valid?
      redirect_to edit_admin_badge_path(@badge), notice: "Badge saved!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    parms = params[:badge]
    parms[:admin_id] = current_user.id
    if params[:redeem] == "purchase"
      parms[:code] = nil
      parms[:price] = (parms[:price].to_f * 100).to_i
    else
      parms[:price] = nil
    end
    @badge.update_attributes(parms)
    if @badge.valid?
      redirect_to edit_admin_badge_path(@badge), notice: "Badge saved!"
    else
      flash.now[:alert] = "There was a problem: #{@badge.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @badge.destroy
    redirect_to admin_badges_path, notice: "Badge deleted"
  end
  
  def mass_new
  end
  
  def mass_create
    num = params[:number].to_i
    badge_params = { :level => params[:badge_level], :explain => params[:explain], :admin_id => current_user.id }
    num.times do
      if params[:redeem] == "code"
        badge_params[:code] = SecureRandom.hex(4)
        badge_params[:price] = nil
      else
        badge_params[:code] = nil
        badge_params[:price] = (params[:price].to_f * 100).to_i
      end
      Badge.create(badge_params)
    end
    redirect_to admin_badges_path, notice: "Badges created"
  end
  
  def export
    csv = ""
    Badge.where("code is not null and user_id is null").find_each do |b|
      csv << "#{b.level}, #{b.code}\n"
    end
    send_data csv, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=badge_codes_#{Time.now.to_i}.csv"
  end
  
  private
    def find_badge
      @badge = Badge.find_by_id(params[:id])
      redirect_to :index, alert: "Sorry, couldn't find that badge" unless @badge.present?
    end
end
