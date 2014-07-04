require 'spec_helper'

describe Dispatch do
  let(:time) { Time.now }

  it { should belong_to(:report) }
  it { should belong_to(:responder) }
  it { should validate_presence_of(:report) }
  it { should validate_presence_of(:responder) }
  it { should delegate_method(:responder_name).to(:responder).as(:name) }
  it { should delegate_method(:report_address).to(:report).as(:address) }

  describe 'scope' do
    let(:dispatch)           { create(:dispatch, created_at: time - 10.minutes) }
    let(:dispatch_accepted)  { create(:dispatch, :accepted, created_at: time - 5.minutes) }
    let(:dispatch_completed) { create(:dispatch, :completed, created_at: time - 3.minutes) }
    let(:dispatch_rejected)  { create(:dispatch, :rejected) }

    describe 'default scope' do
      subject { Dispatch.all }
      it { should start_with(dispatch_rejected, dispatch_completed, dispatch_accepted, dispatch) }
    end

    describe '.pending' do
      subject { Dispatch.pending }
      it { should start_with(dispatch) }
      it { should_not include(dispatch_accepted, dispatch_rejected, dispatch_completed) }
    end

    describe '.not_rejected' do
      subject { Dispatch.not_rejected }
      it { should include(dispatch_accepted, dispatch, dispatch_completed) }
      it { should_not include(dispatch_rejected) }
    end
  end

  # Class
  describe '.accepted' do
    let(:dispatch_accepted)  { create(:dispatch, :accepted, created_at: time - 10.minutes) }
    let(:dispatch_completed) { create(:dispatch, :completed, created_at: time - 5.minutes) }
    let(:dispatch)           { create(:dispatch) }
    subject                  { Dispatch.accepted }

    it { should include(dispatch_completed, dispatch_accepted) }
  end

  describe 'counters' do
    before do
      create_list(:dispatch, 3, :completed)
      create_list(:dispatch, 4, :rejected)
      create_list(:dispatch, 2)
    end

    describe '.completed_count' do
      subject { Dispatch.completed_count }
      it { should eq(3) }
    end

    describe '.rejected_count' do
      subject { Dispatch.rejected_count }
      it { should eq(4) }
    end
  end

  describe 'status state' do
    subject(:dispatch) { build(:dispatch) }

    describe '#accepted?' do
      before { dispatch.status = 'accepted' }
      its(:accepted?) { should be_true }
      it 'is false unless accepted' do
        dispatch.status = 'archived'
        expect(dispatch.accepted?).to be_false
      end
    end

    describe '#completed?' do
      before { dispatch.status = 'completed' }
      its(:completed?) { should be_true }
      it 'is false unless completed' do
        dispatch.status = 'accepted'
        expect(dispatch.completed?).to be_false
      end
    end

    describe '#pending?' do
      before { dispatch.status = 'pending' }
      its(:pending?) { should be_true }
      it 'is false unless pending' do
        dispatch.status = 'accepted'
        expect(dispatch.pending?).to be_false
      end
    end
  end

  describe '#status_update' do
    subject { create(:dispatch) }
    its(:status_update) { should include(subject.responder_name, subject.status) }
  end

  context 'when created' do
    let(:report) { create :report }
    let(:responder) { create :responder }

    it 'hits #messanger with pending status' do
      expect_any_instance_of(DispatchMessanger).to receive(:pending!)
      report.dispatch!(responder)
    end
  end
end
