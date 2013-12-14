require 'spec_helper'

describe Responder do
  describe '#dispatch_to' do
    let(:report) { create :report, :unassigned }
    let(:responder) { create :responder }

    it 'changes the status of the given report' do
      -> { responder.dispatch_to report }.should change(report, :status)
    end
  end
end
