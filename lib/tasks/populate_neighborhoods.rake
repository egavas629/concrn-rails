task :populate_neighborhoods => :environment do
	Report.all.each do |report|
		report.find_neighborhood
		report.save
	end
end