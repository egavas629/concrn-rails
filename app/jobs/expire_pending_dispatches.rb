class ExpirePendingDispatches
  def self.queue
    "dispatches"
  end

  def self.perform
    Dispatch.where(status: "pending").where("created_at < ?", 2.minutes.ago).update_all(status: "rejected", rejection_reason: "timeout")
  end
end
