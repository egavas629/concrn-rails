class Api::UsersController < ApplicationController
	 before_filter :find_user

	def is_user_responder
    status = @user.present? && @user.responder?
    render json: { result_value: status }
  end

  def responder_shift_has_started
    status = @user.shifts.started?
    render json: { result_value: status }
  end

  def start_responder_shift
  	@user.shifts.start
  	head :ok
  end

  def end_responder_shift
  	@user.shifts.end
  	head :ok
  end

private

  def find_user
    @user = User.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
  end

end

