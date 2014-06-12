require 'spec_helper'

describe Report do
  describe 'scopes' do
    describe '.unassigned'
    describe '.pending'
    describe '.accepted'
    describe '.completed'
  end

  describe '#accept_feedback' do
    let(:report) { create :report, :assigned }
    let(:jacob) { report.responders.first }

    it 'creates a new log' do
      ->{
        DispatchMessanger.new(jacob).respond('You done good')
      }.should change { report.logs.count }.by(1)
    end
  end

  describe 'leaving notes on a completed report' do
    let(:report) { create :report, :completed }
    let(:rachel) { report.responders.first }
    let(:messanger) { DispatchMessanger.new(rachel) }

    it 'does not reopen the report' do
      ->{ messanger.respond("He was still there, this morning.") }.
      should_not change(report, :status).from('completed')
    end
  end

  describe '#dispatch' do
    let(:report) { create :report }
    let(:jane) { create :responder }

    # it 'messages the potential responder' do
    #   report.dispatch! jane
    #   expect(Message).to receive(:send).with(anything, to: jane.phone)
    # end
  end
end
