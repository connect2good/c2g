class DonationsController < ApplicationController
  before_action :authenticate_individual!
  def index
    @donations = Donation.all
  end

  def new
    @need = Need.find(params[:need_id])
    @need_name = @need_name = @need.organization.name
    @donation = @need.donations.new

  end

  def create
    @need = Need.find(params[:need_id])
    @donation = @need.donations.new(donations_params)
    @donation.status = "pending"
    # Must update donor_id dynamically
    @donation.donor_id = current_individual.id
    @donation.pic1 = params[:pic1]
    @donation.pic2 = params[:pic2]
    @donation.pic3 = params[:pic3]
    if @donation.save
      redirect_to @donation, notice: "Your donation has been submitted"
    else
      render 'new'
    end
  end

  def show
    @donation = Donation.find(params[:id])
  end


private
  def donations_params
    params.require(:donation).permit(:description, :pic1, :pic2, :pic3)
  end
end
