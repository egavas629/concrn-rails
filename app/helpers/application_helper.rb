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
end
