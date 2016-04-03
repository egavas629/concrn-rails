task :populate_neighborhoods do |variable|
	Report.each do |report|
		report.find_neighborhood
	end
end