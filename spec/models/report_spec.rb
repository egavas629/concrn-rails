require 'spec_helper'

describe Report do
  describe 'scopes' do
    describe '.unassigned'
    describe '.pending'
    describe '.accepted'
    describe '.completed'
  end

  describe '#unassigned?' do
    let(:responder) { create :responder }
    let(:report) { create :report }

    it 'returns true until a responder is dispatched to the report' do
      ->{
          responder.dispatch_to report
        }.should change(report, :unassigned?).from(true).to(false)
    end
  end
  describe '#pending?'
  describe '#accepted?'
  describe '#completed?'
  describe '#dispatched?'

  describe '#responder_synopsis'
  describe '#current_dispatch'
  describe '#reporter_synopsis'
  describe '#freshness'
  describe '#status'
  describe '#accept_feedback(opts={})'
end
