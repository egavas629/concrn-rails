require 'spec_helper'

describe Dispatch do
  let(:time) { Time.now.utc }

  it { should belong_to(:report) }
  it { should belong_to(:responder) }
  it { should validate_presence_of(:report) }
  it { should validate_presence_of(:responder) }
  it { should ensure_inclusion_of(:status).in_array(Dispatch::STATUS) }
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

  describe '#accept' do
    subject { create(:dispatch) }
    before  { Dispatch.any_instance.stub(:messanger) }

    context 'status not accepted' do
      before { subject.accept }
      its(:accepted_at) { should be_nil }
    end

    context 'status accepted' do
      let(:day) { time.day }
      before do
        subject.status = 'accepted'
        subject.accept
      end
      its("accepted_at.day") { should eq(day) }
    end
  end

  describe '#complete!' do
    subject { create :dispatch, :accepted }
    
    it 'sets status to complete' do
      expect {
        subject.complete!
      }.to change { subject.reload.status }.from('accepted').to('completed')
    end
    
    it 'completes sibling dispatches' do
      sibling = create :dispatch, report: subject.report
      
      expect {
        subject.complete!
      }.to change { sibling.reload.status }.from('pending').to('completed')
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

    describe '#rejected?' do
      before { dispatch.status = 'rejected' }
      its(:rejected?) { should be_true }
      it 'is false unless rejected' do
        dispatch.status = 'accepted'
        expect(dispatch.rejected?).to be_false
      end
    end
  end

  describe '#status_update' do
    subject { create(:dispatch) }
    its(:status_update) { should include(subject.responder_name, subject.status) }
  end

  describe '#messanger' do
    context 'after_create' do
      subject { build(:dispatch) }
      it 'runs' do
        expect(subject).to receive(:messanger).once
        subject.save
      end
    end

    context 'after_update' do
      subject { create(:dispatch) }

      context 'status changed' do
        before { subject.status = 'rejected' }
        it 'runs' do
          expect(subject).to receive(:messanger).once
          subject.save
        end
      end

      context 'status unchanged' do
        it 'doesn\'t run' do
          expect(subject).to_not receive(:messanger)
          subject.save
        end
      end
    end
  end

  describe '#push_reports' do
    context 'after_commit' do
      subject { build(:dispatch) }
      it 'should trigger' do
        expect(subject).to receive(:push_reports)
        subject.save
      end
    end
  end
end
