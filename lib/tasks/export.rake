task :export => :environment do
	Dir[Rails.root.join('app/models/*.rb').to_s].each do |filename|
		klass = File.basename(filename, '.rb').camelize.constantize
		next unless klass.ancestors.include?(CsvExportable)
		puts klass
		puts klass.to_csv
		puts
	end
end
