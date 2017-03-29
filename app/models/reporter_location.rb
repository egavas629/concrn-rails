class ReporterLocation < ActiveRecord::Base
  include CsvExportable

  belongs_to :user
end
