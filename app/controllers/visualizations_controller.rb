class VisualizationsController < ApplicationController
	before_action :authenticate_user!
	

	def reports_charts
		reports = Report.all
		reports_by_month = []
		months_hash = {}
		(1..12).each do |month|
			months_hash[month] = []
		end

		reports_by_month = reports.group_by {|report| report.created_at.month}
		@data = []
		reports_by_month.each do |key, value|
			months_hash[key] = value
		end
		months_hash.each do |key, value|
			@data << value.count
		end
		@data
	end
end
