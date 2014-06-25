class ShiftsController < ApplicationController
  before_action :find_responder

  def start
    respond_to do |format|
      if @responder.shifts.start!
        flash[:notice] = "#{@responder.name}'s shift has started."
      else
        flash[:alert]  = "Error starting #{@responder.name}'s shift."
      end
      format.html { redirect_to :back }
    end
  end

  def end
    respond_to do |format|
      if @responder.shifts.end!
        flash[:notice] = "#{@responder.name}'s shift has ended."
      else
        flash[:alert]  = "Error ending #{@responder.name}'s shift."
      end
      format.html { redirect_to :back }
    end
  end

private

  def find_responder
    @responder = Responder.find(responder_id)
  end

  def responder_id
    params[:id]
  end

end
