require 'csv'

module CsvExportable
  extend ActiveSupport::Concern

  module ClassMethods
    def sensitive_fields(*fields)
      @sensitive_fields = fields.map(&:to_s)
    end

    def to_csv
      CSV.generate do |csv|
        exclude_fields = @sensitive_fields || []
        csv << (attribute_names - exclude_fields)
        find_each do |record|
          csv << record.attributes.except(*exclude_fields).values
        end
      end
    end
  end
end
