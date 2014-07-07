class ResponderPresenter < BasePresenter
  presents :responder

  def status
    dispatches = responder.dispatches
    dispatches.none? ? "unassigned" : "last: #{dispatches.first.status}"
  end
end
