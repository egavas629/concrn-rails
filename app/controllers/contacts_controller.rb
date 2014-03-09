class ContactsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  before_filter :ensure_dispatcher, only: %w(index active history)

  def new
    @blank_contact = Contact.new
  end

end
