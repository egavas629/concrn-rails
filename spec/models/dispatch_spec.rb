require 'spec_helper'

describe Dispatch do
  it { should belong_to(:report) }
  it { should belong_to(:responder) }
  it { should validate_presence_of(:report) }
  it { should validate_presence_of(:responder) }
  it { should delegate_method(:responder_name).to(:responder).as(:name) }
  it { should delegate_method(:report_address).to(:report).as(:address) }

  describe 'scope' do
    subject(:dispatch)           { create(:dispatch) }
    subject(:dispatch_accepted)  { create(:dispatch, :accepted)}
    subject(:dispatch_completed) { create(:dispatch, :completed)}
    subject(:dispatch_rejected)  { create(:dispatch, :rejected)}

    describe 'default scope' do
      subject(:dispatches) { Dispatch.all }

      it 'orders dispatches by created_at time desc' do
        expect(dispatches).to match_array([dispatch_rejected, dispatch_completed, dispatch_accepted, dispatch])
      end
    end

    describe '.pending' do
      subject(:dispatches_pending) { Dispatch.pending }

      it 'includes pending dispatches' do
        expect(dispatches_pending).to match_array([dispatch])
      end
      it 'excludes non-pending dispatches' do
        expect(dispatches_pending).to_not include(dispatch_accepted, dispatch_rejected, dispatch_completed)
      end
    end

    describe '.not_rejected' do
      subject(:dispatch_not_rejected) { Dispatch.not_rejected }

      it 'includes non_rejected' do
        expect(dispatch_not_rejected).to include(dispatch_accepted, dispatch, dispatch_completed)
      end
      it 'excludes rejected' do
        expect(dispatch_not_rejected).to_not include(dispatch_rejected)
      end
    end
  end

  # Class
  describe '.accepted' do
    subject(:dispatch_accepted)  { create(:dispatch, :accepted) }
    subject(:dispatch_completed) { create(:dispatch, :completed) }
    subject(:dispatch)           { create(:dispatch) }
    subject(:dispatches)         { Dispatch.accepted }
    
    it 'only includes accepted/completed dispatches' do
      expect(dispatches).to match_array([dispatch_completed, dispatch_accepted])
    end
  end

  describe 'counters' do
    before do
      create_list(:dispatch, 3, :completed)
      create_list(:dispatch, 4, :rejected)
      create_list(:dispatch, 2)
    end

    it '.completed_count' do
      expect(Dispatch.completed_count).to eq(3)
    end
    it '.rejected_count' do
      expect(Dispatch.rejected_count).to eq(4)
    end
  end

  describe 'status state' do
    subject(:dispatch) { build(:dispatch) }

    describe '#accepted?' do
      it 'is true if accepted' do
        dispatch.status = 'accepted'
        expect(dispatch.accepted?).to be_true
      end
      it 'is false if not accepted' do
        expect(dispatch.accepted?).to be_false
      end
    end

    describe '#completed?' do
      it 'is true if completed' do
        dispatch.status = 'completed'
        expect(dispatch.completed?).to be_true
      end
      it 'is false if not completed' do
        dispatch.status = 'accepted'
        expect(dispatch.completed?).to be_false
      end
    end

    describe '#pending?' do
      it 'is true if pending' do
        dispatch.status = 'pending'
        expect(dispatch.pending?).to be_true
      end
      it 'is false if not pending' do
        dispatch.status = 'accepted'
        expect(dispatch.pending?).to be_false
      end
    end

  end

  describe '#status_update' do
    subject(:dispatch) { create(:dispatch) }

    it 'includes responder_name' do
      expect(dispatch.status_update).to include(dispatch.responder_name, dispatch.status)
    end
  end

  context 'when created' do
    let (:report) { create :report }
    let (:responder) { create :responder }

    it 'hits #messanger with pending status' do
      expect_any_instance_of(DispatchMessanger).to receive(:pending!)
      report.dispatch!(responder)
    end
  end
end
