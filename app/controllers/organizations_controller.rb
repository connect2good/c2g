class OrganizationsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @organizations = Organization.where(status: true)
  end

  def show
    @organization = Organization.find(params[:id])
    @org_sorted = @organization.needs.order(sort_column + " " + sort_direction)
    @needs = @organization.needs.page(params[:page])
    @need = Need.new 
    @pending = 0
    @offers = @organization.offers
    @offers.each do |offer|
      offer.status == "pending" ? @pending += 1 : @pending
    end  
    @denied = 0
    @offers.each do |offer|
      offer.status == "declined" ? @denied += 1 : @denied
    end  

    @accepted = 0
    @offers = @organization.offers
    @offers.each do |offer|
      offer.status == "accepted" ? @accepted += 1 : @accepted
    end

    @active = 0
    @needs.each do |need|
      need.status == true ? @active += 1 : @active
    end

    respond_to do |format|
      format.html { render action: 'show' }
      format.js { render layout: false }
    end
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.update(organization_params)
    respond_to do |format|
        format.html { redirect_to :back }
        format.js { render :layout => false }
        
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.owner = current_user
    @organization.save
    respond_to do |format|
      format.html { redirect_to @organization }
      format.js { render layout: false }
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:description, :owner_id, :image, :name, :email, :status, :street, :city, :state, :zip)
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    params[:direction] || "desc"
  end
end