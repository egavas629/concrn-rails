class ReportFilter
  WHITELIST_ATTRIBUTES = %w(name phone start_date end_date responder)

  def initialize(params)
    @params     = params.keep_if {|key,val| WHITELIST_ATTRIBUTES.include?(key)}
    start_date  = params[:start_date]
    end_date    = params[:end_date]

    @responder_params = params[:responder]

    @start_date = Date.parse(start_date).end_of_day if start_date.present?
    @end_date   = Date.parse(end_date).end_of_day if end_date.present?
  end

  # NOTE
  # (in block after) elsif defined?(@responder_params)....
  # Needed compact once for edge case but cant repeat so feel free to take out
  def query
    if defined?(@start_date) && defined?(@end_date)
      completed_reports.where('created_at >= ? and created_at <= ?', @start_date, @end_date).order('created_at desc')
    elsif defined?(@start_date)
      completed_reports.where('created_at >= ?', @start_date).order(:created_at)
    elsif defined?(@end_date)
      completed_reports.where('created_at <= ?', @end_date).order('created_at desc')
    elsif defined?(@responder_params) && @responder_params.present?
      Responder.where(@responder_params).map(&:reports).flatten.compact.sort { |a,b| b.created_at <=> a.created_at }
    else
      completed_reports.where(@params).order('created_at desc')
    end
  end

private

  def completed_reports
    Report.where(status: 'completed')
  end

end
