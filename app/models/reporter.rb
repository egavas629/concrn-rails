class Reporter < User
  include CsvExportable
  sensitive_fields :email, :name, :phone

  belongs_to :user, class_name: User, foreign_key: :id
  default_scope -> { where(role: 'reporter') }
end
