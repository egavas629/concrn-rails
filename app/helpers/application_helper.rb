module ApplicationHelper
  def row_style(status)
    case status
    when 'rejected'
      'danger'
    when 'pending'
      'warning'
    when 'archived'
      'info'
    when 'completed'
      'success'
    when 'unassigned'
      'warning'
    end
  end

  def present(object, klass = nil)
    klass ||= "{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
