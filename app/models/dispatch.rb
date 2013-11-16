class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder
end
