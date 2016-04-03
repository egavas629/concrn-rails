class VisualizationsController < ApplicationController

	def reports_timeline_map
		# render: "visualizations/reports_timeline_map"
	end

	def reports_charts
		data = []
		@ordered_reports = report.order(:created_at)
		@reports_by_month = []
		@reports_by_month.each do |report|
			report.created_at
	end
end
