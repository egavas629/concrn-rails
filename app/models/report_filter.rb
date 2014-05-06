class ReportFilter
  WHITELIST_ATTRIBUTES = %w(name phone start_date end_date responder)

  def initialize(params, agency_id)
    @params     = params.keep_if {|key,val| WHITELIST_ATTRIBUTES.include?(key)}
    start_date  = params[:start_date]
    end_date    = params[:end_date]

    @responder_params = params[:responder]

    @agency_id  = agency_id
    @start_date = Date.parse(start_date).end_of_day if start_date.present?
    @end_date   = Date.parse(end_date).end_of_day if end_date.present?
  end

  def query
    if defined?(@start_date) && defined?(@end_date)
      agencies_completed_reports.where('created_at >= ? and created_at <= ?', @start_date, @end_date).order('created_at desc')
    elsif defined?(@start_date)
      agencies_completed_reports.where('created_at >= ?', @start_date).order(:created_at)
    elsif defined?(@end_date)
      agencies_completed_reports.where('created_at <= ?', @end_date).order('created_at desc')
    elsif defined?(@responder_params) && @responder_params.present?
      reports_ary = []
      Responder.where(@responder_params).map(&:reports).each do |reports|
        reports.each do |report|
          reports_ary << report if report.present? && report.completed?
        end
      end
      reports_ary.uniq.sort { |a,b| b.created_at <=> a.created_at }
    else
      agencies_completed_reports.where(@params).order('created_at desc')
    end
  end

private

  def agencies_completed_reports
    Report.where(status: 'completed', agency_id: @agency_id)
  end

end
