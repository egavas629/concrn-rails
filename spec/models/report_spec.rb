require 'spec_helper'

describe Report do
  it { should have_many(:dispatches).dependent(:destroy) }
  it { should have_many(:logs).dependent(:destroy) }
  it { should have_many(:responders).through(:dispatches) }

  describe 'scopes' do
    subject(:report)           { create(:report) }
    subject(:accepted_report)  { create(:report, :accepted) }
    subject(:archived_report)  { create(:report, :archived) }
    subject(:completed_report) { create(:report, :completed) }
    subject(:pending_report)   { create(:report, :pending) }
    subject(:rejected_report)  { create(:report, :rejected) }

    before do
      accepted_report.reload
      pending_report.reload
    end

    describe '.accepted' do
      it 'should include accepted reports' do
        expect(Report.accepted).to include(accepted_report)
      end
      it 'should exclude non-accepted reports' do
        expect(Report.accepted).to_not include(report, archived_report, pending_report, rejected_report)
      end
    end
    describe '.completed' do
      it 'should include completed reports' do
        expect(Report.completed).to include(completed_report, archived_report)
      end

      it 'should exclude non-completed reports' do
        expect(Report.completed).to_not include(report, accepted_report, pending_report, rejected_report)
      end
    end
    describe '.pending' do
      it 'should include pending reports' do
        expect(Report.pending).to include(pending_report)
      end
      it 'should exclude non-pending reports' do
        expect(Report.pending).to_not include(report, accepted_report, archived_report, completed_report, rejected_report)
      end
    end
    describe '.unassigned' do
      it 'should include unassigned reports' do
        expect(Report.unassigned).to include(rejected_report, report)
      end

      it 'should exclude assigned reports' do
        expect(Report.unassigned).to_not include(accepted_report, archived_report, completed_report, pending_report)
      end
    end
  end

  describe '#clean_image' do
    subject(:report) { create(:report, :image_attached) }

    it 'should remove image if delete_image true' do
      report.delete_image = '1'
      report.clean_image
      expect(report.image.url).to eq("/images/original/missing.png")
    end

    it 'should keep image if delete_image false' do
      report.delete_image = '0'
      report.clean_image
      expect(report.image.url).not_to eq("/images/original/missing.png")
    end
  end

  describe '#clean_observations' do
    it 'should delete blank elements in array' do
      report = create(:report, observations: ['Agitated', '', 'Hungry', nil])
      expect(report.observations).to match_array(['Agitated', 'Hungry'])
    end

    it 'should be able to handle empty array' do
      report = create(:report, observations: ['', nil])
      expect(report.observations).to match_array([])
    end
  end

  describe 'status states' do
    subject(:report)           { create(:report) }
    subject(:accepted_report)  { create(:report, :accepted) }
    subject(:archived_report)  { create(:report, :archived) }
    subject(:completed_report) { create(:report, :completed) }
    subject(:pending_report)   { create(:report, :pending) }
    subject(:rejected_report)  { create(:report, :rejected) }
    before { completed_report.reload }

    describe '#current_status' do
      it 'should be active if accepted responders' do
        expect(accepted_report.current_status).to eq('active')
      end
      it 'should be pending when no accepted responders' do
        expect(pending_report.current_status).to eq('pending')
      end
      it 'should be unassigned if no dispatches' do
        expect(report.current_status).to eq('unassigned')
      end
      it 'should be unassigned if rejected dispatches' do
        expect(rejected_report.current_status).to eq('unassigned')
      end
      it 'should be completed' do
        expect(completed_report.current_status).to eq('completed')
      end
      it 'should be archived' do
        expect(archived_report.current_status).to eq('archived')
      end
    end

    describe '#current_pending?' do
      it 'is true when pending responders' do
        expect(pending_report.current_pending?).to be_true
      end
      it 'is false when rejected' do
        expect(rejected_report.current_pending?).to be_false
      end
      it 'is false when accepted' do
        expect(pending_report.current_pending?).to be_true
      end
      it 'is false when accepted + pending' do
        accepted_report.dispatch!(create(:responder, :on_shift))
        expect(accepted_report.current_pending?).to be_false
      end
    end

    describe '#accepted?' do
      it 'is accepted' do
        expect(accepted_report.accepted?).to be_true
      end
      it 'is pending' do
        expect(pending_report.accepted?).to be_false
      end
      it 'is rejected' do
        expect(rejected_report.accepted?).to be_false
      end
    end

    describe '#archived?' do
      it 'is accepted' do
        expect(accepted_report.archived?).to be_false
      end
      it 'is archived' do
        expect(archived_report.archived?).to be_true
      end
      it 'is completed' do
        expect(completed_report.archived?).to be_false
      end
      it 'is pending' do
        expect(pending_report.archived?).to be_false
      end
      it 'is rejected' do
        expect(rejected_report.archived?).to be_false
      end
    end

    describe '#completed?' do
      it 'is accepted' do
        expect(accepted_report.completed?).to be_false
      end
      it 'is archived' do
        expect(archived_report.completed?).to be_false
      end
      it 'is completed' do
        expect(completed_report.completed?).to be_true
      end
      it 'is pending' do
        expect(pending_report.completed?).to be_false
      end
      it 'is rejected' do
        expect(rejected_report.completed?).to be_false
      end
    end

    describe '#archived_or_completed?' do
      it 'is accepted' do
        expect(accepted_report.archived_or_completed?).to be_false
      end
      it 'is archived' do
        expect(archived_report.archived_or_completed?).to be_true
      end
      it 'is completed' do
        expect(completed_report.archived_or_completed?).to be_true
      end
      it 'is pending' do
        expect(pending_report.archived_or_completed?).to be_false
      end
      it 'is rejected' do
        expect(rejected_report.archived_or_completed?).to be_false
      end
    end

  end

  describe '#complete!' do
    it 'should complete attributes' do
      report = create(:report)
      report.complete!
      expect(report.status).to eq('completed')
    end
  end

  describe '#set_completed!' do
    # Use update_attribute to not trigger callbacks
    it 'should reject pending responders' do
      report = create(:report, :pending)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.dispatches.sample.status).to eq('rejected')
    end

    it 'should complete accepted responders' do
      report = create(:report, :accepted)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.dispatches.sample.status).to eq('completed')
    end

    it 'should give completed time' do
      report = create(:report)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.completed_at).to be < Time.now
    end
  end
end
