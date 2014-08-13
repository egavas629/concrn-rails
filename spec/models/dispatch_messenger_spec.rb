require 'spec_helper'

describe DispatchMessenger do
  describe '.initialize'
  describe '.respond'
  describe '.accept'
  describe '.complete'
  describe '.pending'
  describe '.reject'
  # Private
  describe '.acknowledge_acceptance'
  describe '.acknowledge_rejection'
  describe '.give_feedback'
  describe '.non_breaktime'
  describe '.notify_reporter'
  describe '.primary_responder'
  describe '.reporter_synopsis'
  describe '.responder_synopsis'
  describe '.thank_responder'
  describe '.thank_reporter'

  # describe '#messanger' do
  #   context 'accepted' do
  #     subject    { build(:dispatch, status: 'accepted') }
  #     it 'DispatchMessenger receives #accept!' do
  #       expect_any_instance_of(DispatchMessenger).to receive(:accept!)
  #       subject.save!
  #     end
  #   end
  #   context 'completed' do
  #     subject    { build(:dispatch, status: 'completed') }
  #     it 'DispatchMessenger receives #complete!' do
  #       expect_any_instance_of(DispatchMessenger).to receive(:complete!)
  #       subject.save!
  #     end
  #   end
  #   context 'pending' do
  #     let(:report)    { create(:report) }
  #     let(:responder) { create(:responder, :on_shift) }
  #     it 'DispatchMessenger receives #pending!' do
  #       expect_any_instance_of(DispatchMessenger).to receive(:pending!)
  #       report.dispatch!(responder)
  #     end
  #   end
  #   context 'rejected' do
  #     subject    { build(:dispatch, status: 'rejected') }
  #     it 'DispatchMessenger receives #reject!' do
  #       expect_any_instance_of(DispatchMessenger).to receive(:reject!)
  #       subject.save!
  #     end
  #   end
  # end

end
