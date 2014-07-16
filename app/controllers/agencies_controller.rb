class AgenciesController < ApplicationController
  before_filter :find_agency, only: %w(destroy edit show update)
  before_filter :new_agency,  only: %w(create new)
  before_filter :authenticate_super_admin!

  def create
    @agency.assign_attributes(agency_parameters)
    if @agency.save
      flash[:notice] = "#{@agency.name} was created successfully"
      redirect_to @agency
    else
      flash[:notice] = "There was an error creating the agency"
      render :new
    end
  end

  def destroy
    name = @agency.name
    if @agency.destroy
      flash[:notice] = "#{name} was deleted successfully"
      redirect_to action: :index
    else
      flash[:notice] = "There was an error deleting the agency"
      redirect_to :back
    end
  end

  def edit
  end

  def index
    @agencies = Agency.all
  end

  def new
  end

  def show
    @user = User.new
  end

  def update
    if @agency.update_attributes(agency_parameters)
      flash[:notice] = "#{@agency.name} was updated successfully"
      redirect_to @agency
    else
      flash[:notice] = "There was an updating the agency"
      redirect_to :back
    end
  end

  private

  def find_agency
    @agency = Agency.find(params[:id])
  end

  def new_agency
    @agency = Agency.new
  end

  def agency_parameters
    params.require(:agency).permit(:name, :address, :call_phone, :text_phone)
  end
end
