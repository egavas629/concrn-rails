require 'spec_helper'

describe Dispatch do
  it { should belong_to(:report) }
  it { should belong_to(:responder) }
  it { should validate_presence_of(:report) }
  it { should validate_presence_of(:responder) }

  describe 'default scope'
  describe '.pending'
  describe '.not_rejected'
  describe '.latest'
  describe '.accepted'
  describe '.completed_count'
  describe '.rejected_count'
  describe '#accepted?'
  describe '#completed?'
  describe '#pending?'
  describe '#status_update'
  describe '#messanger'

  # context 'when created' do
  #   let (:report) { create :report }
  #   let (:responder) { create :responder }
  #   it 'sends all the synopses to the responder' do
  #     report.dispatch!(responder)
  #     expect(Telephony).to receive(:send).exactly(5).times
  #   end
  # end
end
