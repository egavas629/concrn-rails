require "spec_helper"

describe ReportsController do
  context "when completing report" do
    let(:report) { create(:report, :accepted) }
    let(:additional_responder) { create(:responder) }

    before { request.env['HTTP_REFERER'] = '/reports' }

    it "notifies dispatchers the report is complete" do
      report.dispatch(additional_responder)

      report.dispatches.each do |dispatch|
        dispatch.update_attribute(:status, 'accepted')
      end

      notified = []
      allow(Telephony).to receive(:send) do |body, to|
        next unless body =~ /The report is now completed/
        fail "#{to} has already been notified" if notified.include?(to)
        notified << to
      end

      put :update, id: report.id, report: { status: 'completed' }
      notified.should have(report.responders.count).items
    end

    it "notifies reporter once" do
      received = false
      
      allow(Telephony).to receive(:send) do |body, to|
        next unless body =~ /Report resolved, thanks for being concrned!/
        fail "#{to} has already been notified" if received
        received = true
      end

      put :update, id: report.id, report: { status: 'completed' }
      expect(received).to be
    end
  end
end
