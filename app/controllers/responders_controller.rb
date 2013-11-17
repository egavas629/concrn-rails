class RespondersController < ApplicationController
  def index
    @responders = Responder.all
  end
end
