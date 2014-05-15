class ReportFilter

  def initialize(params)
    start_date  = params[:start_date]
    end_date    = params[:end_date]
    
    order       = params[:order]
    order       = order.present? ? order : 'desc' && params[:order] = 'desc'
    @order      = "created_at #{order}"

    @start_date = Date.parse(start_date).end_of_day if start_date.present?
    @end_date   = Date.parse(end_date).end_of_day if end_date.present?
  end

  def query
    if defined?(@start_date) && defined?(@end_date)
      completed_reports.where('created_at >= ? and created_at <= ?', @start_date, @end_date).order(@order)
    elsif defined?(@start_date)
      completed_reports.where('created_at >= ?', @start_date).order(@order)
    elsif defined?(@end_date)
      completed_reports.where('created_at <= ?', @end_date).order(@order)
    else
      completed_reports.where(@params).order(@order)
    end
  end

private

  def completed_reports
    Report.completed
  end

end
