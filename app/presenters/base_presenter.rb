class BasePresenter
  def initialize(object)
    @object = object
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

protected

  def h
    ActionController::Base.helpers
  end

  def url
    Rails.application.routes.url_helpers
  end

end
