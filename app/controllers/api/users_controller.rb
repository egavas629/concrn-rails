class Api::UsersController < ApplicationController

	def verify_responder_by_phone
    @user = User.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
    status = @user.present? && @user.responder?
    render json: { result_value: status }
  end

    def start
    respond_to do |format|
      if @user.shifts.start
        flash[:notice] = "#{@user.name}'s shift has started."
      else
        flash[:alert]  = "Error starting #{@user.name}'s shift."
      end
      format.html { redirect_to :back }
    end
  end

  def end
    respond_to do |format|
      if @user.shifts.end
        flash[:notice] = "#{@user.name}'s shift has ended."
      else
        flash[:alert]  = "Error ending #{@user.name}'s shift."
      end
      format.html { redirect_to :back }
    end
  end

private

  def find_user
    @user = users.find(user_id)
  end

  def user_id
    params[:id]
  end

end

