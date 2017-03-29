require 'csv'

module CsvExportable
  extend ActiveSupport::Concern

  module ClassMethods
    def sensitive_fields(*fields)
      @sensitive_fields = fields.map(&:to_s)
    end

    def to_csv
      CSV.generate do |csv|
        csv << attribute_names
        find_each do |record|
          csv << _hash_sensitive_values(record.attributes).values
        end
      end
    end

    private

    def _hash_sensitive_values(attributes)
      hash_fields = @sensitive_fields || []
      Hash[attributes.map do |k,v|
        if v and hash_fields.include?(k)
          [k, Digest::SHA256.hexdigest(v)]
        else
          [k, v]
        end
      end]
    end
  end
end
