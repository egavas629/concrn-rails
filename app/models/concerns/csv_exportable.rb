require 'csv'

module CsvExportable
  extend ActiveSupport::Concern

  module ClassMethods
    def to_csv
      CSV.generate do |csv|
        csv << attribute_names
        find_each do |record|
          csv << record.attributes.values
        end
      end
    end
  end
end
