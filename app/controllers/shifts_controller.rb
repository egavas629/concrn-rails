class ShiftsController < ApplicationController
  before_action :find_responder

  def start
    p '********************'
    puts params.inspect
    respond_to do |format|
      if @responder.shifts.start!
        flash[:notice] = "#{@responder.name}'s shift successfully started"
      else
        flash[:alert]  = "Error creating #{@responder.name}'s shift"
      end
      format.html { redirect_to :back }
    end
  end

  def end
    p '********************'
    puts params.inspect
    respond_to do |format|
      if @responder.shifts.end!
        flash[:notice] = "#{@responder.name}'s shift successfully ended"
      else
        flash[:alert]  = "Error ending #{@responder.name}'s shift"
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
