class ExpirePendingDispatches
  def self.queue
    "dispatches"
  end

  def self.perform
    stales = Dispatch.where(status: "pending").where("created_at < ?", 2.minutes.ago)
    stales.each do |dispatch|
      dispatch.update_attributes(status: "rejected", rejection_reason: "timeout")
    end
    Pusher.trigger("reports" , "report_created", {}) if stales.any?
  end
end
