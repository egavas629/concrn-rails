require 'spec_helper'

describe Report do
  describe 'scopes' do
    describe '.unassigned'
    describe '.pending'
    describe '.accepted'
    describe '.completed'
  end

  describe '#accept_feedback' do
    let(:report) { create :report }
    let(:jacob) { create :responder, :jacob }

    it 'creates a new log' do
      ->{
        report.accept_feedback from: jacob, body: 'You done good'
      }.should change { report.logs.count }.by(1)
    end
  end

  describe 'leaving notes on a completed report' do
    let(:report) { create :report, :completed }
    let(:rachel) { report.responder }

    it 'does not reopen the report' do
      ->{ rachel.respond "He was still there, this morning." }.
      should_not change(report, :status).from('completed')
    end
  end
end
