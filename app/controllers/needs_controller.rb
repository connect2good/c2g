class NeedsController < ApplicationController

  def search
  end

  def index
		if params[:query].present? && params[:city].present?
      a = params[:query]
      b = params[:city]
      c = a + " " + b
      @needs = Need.where(status: true).text_search(c).page(params[:page]).per_page(12)
    elsif params[:query].present?
			@needs = Need.where(status: true).text_search(params[:query]).page(params[:page]).per_page(12)
    elsif params[:city].present?
      @needs = Need.where(status: true).text_search(params[:city]).page(params[:page]).per_page(12)
		else
			@needs = Need.where(status: true).page(params[:page]).per_page(12)
		end
		respond_to do |format|
		    format.html
        format.js { redirect_to :back}
		end
	end

	def show
		@need = Need.find(params[:id])
	end

	def need
		@need = Need.find(params[:id])
	end
	def create
		@need = Need.new(needs_params)
		@need.organization_id = params[:organization_id]
    @need.save
    @organization = @need.organization
		respond_to do |format|
      # if need.save
        format.html { redirect_to :back }
        format.js { render layout: false }
      # else
        # format.js
      # end
    end
	end

	def new
		@need = Need.new
	end

	def edit
		@need = Need.find(params[:id])
    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to :back }
    end
	end

	def update
		@need = Need.find(params[:id])
		@need.update(needs_params)
		respond_to do |format|
        format.html { redirect_to :back }
        format.js { render :layout => false }
		end

	end

	def destroy
		@need = Need.find(params[:id])
		@organization = @need.organization
		@need.destroy
		respond_to do |format|
		    format.html { redirect_to :back }
        format.js { render layout: false}
		end
	end

	private
	def needs_params
		params.require(:need).permit(:description, :organization_id, :category, :status)
	end

end
