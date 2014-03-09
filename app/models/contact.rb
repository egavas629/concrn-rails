class Contact < ActiveRecord::Base
  attr_reader :start_time, :end_time, :travel_time, :doc_time, :client_name, :reporting_party, :incident_number, :case_number, :non_call_time, :us_veteran, :referral_type, :contact_method, :service_code, :chart_status, :person_contacted, :place_of_service, :contact_type, :appointment_type, :fifty_one_fifty_status, :insurance, :linkage_time, :linkage_place
end
