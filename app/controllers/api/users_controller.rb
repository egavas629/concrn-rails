class Api::UsersController < ApplicationController
	 before_filter :find_user

	def is_user_responder
    status = @user.present? && @user.responder?
    render json: { result_value: status }
  end

  def has_responder_shift_started
    status = @user.on_duty
    render json: { result_value: status }
  end

  def start_responder_shift
  	@user.update(on_duty: true)
  	head :ok
  end

  def end_responder_shift
  	@user.update(on_duty: false)
  	head :ok
  end

private

  def find_user
    @user = User.find_by_phone(NumberSanitizer.sanitize(params[:phone]))
  end

end

