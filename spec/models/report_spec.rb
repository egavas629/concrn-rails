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
      subject(:accepted_reports) { Report.accepted }

      it 'includes accepted reports' do
        expect(accepted_reports).to match_array([accepted_report])
      end
      it 'excludes non-accepted reports' do
        expect(accepted_reports).to_not include(report, archived_report, pending_report, rejected_report)
      end
    end
    describe '.completed' do
      subject(:completed_reports) { Report.completed }

      it 'includes completed reports' do
        expect(completed_reports).to include(completed_report, archived_report)
      end

      it 'excludes non-completed reports' do
        expect(completed_reports).to_not include(report, accepted_report, pending_report, rejected_report)
      end
    end
    describe '.pending' do
      subject(:pending_reports) { Report.pending }

      it 'includes pending reports' do
        expect(pending_reports).to match_array([pending_report])
      end
      it 'excludes non-pending reports' do
        expect(pending_reports).to_not include(report, accepted_report, archived_report, completed_report, rejected_report)
      end
    end

    describe '.unassigned' do
      subject(:unassigned_reports) { Report.unassigned }

      it 'includes unassigned reports' do
        expect(unassigned_reports).to include(rejected_report, report)
      end

      it 'excludes assigned reports' do
        expect(unassigned_reports).to_not include(accepted_report, archived_report, completed_report, pending_report)
      end
    end
  end

  describe '#clean_image' do
    subject(:report) { build(:report, :image_attached) }

    it 'removes image if delete_image true' do
      report.delete_image = '1'
      report.send(:clean_image)
      expect(report.image.url).to eq("/images/original/missing.png")
    end

    it 'keeps image if delete_image false' do
      report.delete_image = '0'
      report.send(:clean_image)
      expect(report.image.url).not_to eq("/images/original/missing.png")
    end
  end

  describe '#clean_observations' do
    subject(:report) { build(:report) }

    it 'deletes blank elements in array' do
      report.observations = ['Agitated', '', 'Hungry', nil]
      report.send(:clean_observations)
      expect(report.observations).to match_array(['Agitated', 'Hungry'])
    end

    it 'handles empty array' do
      report.observations = ['', nil]
      report.send(:clean_observations)
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
      it 'report is active if any accepted responders' do
        expect(accepted_report.current_status).to eq('active')
      end
      it 'pending report is pending' do
        expect(pending_report.current_status).to eq('pending')
      end
      it 'unassigned report is unassigned' do
        expect(report.current_status).to eq('unassigned')
      end
      it 'rejected report is unassigned' do
        expect(rejected_report.current_status).to eq('unassigned')
      end
      it 'completed report is completed' do
        expect(completed_report.current_status).to eq('completed')
      end
      it 'archived report is archived' do
        expect(archived_report.current_status).to eq('archived')
      end
    end

    describe '#current_pending?' do
      it 'is true if pending responders' do
        expect(pending_report.current_pending?).to be_true
      end
      it 'is false if rejected' do
        expect(rejected_report.current_pending?).to be_false
      end
      it 'is false if accepted' do
        expect(pending_report.current_pending?).to be_true
      end
      it 'is false if accepted or pending' do
        accepted_report.dispatch!(create(:responder, :on_shift))
        expect(accepted_report.current_pending?).to be_false
      end
    end

    describe '#accepted?' do
      it 'is true if accepted' do
        expect(accepted_report.accepted?).to be_true
      end
      it 'is false if pending' do
        expect(pending_report.accepted?).to be_false
      end
      it 'is false if rejected' do
        expect(rejected_report.accepted?).to be_false
      end
    end

    describe '#archived?' do
      it 'is false if accepted' do
        expect(accepted_report.archived?).to be_false
      end
      it 'is true if archived' do
        expect(archived_report.archived?).to be_true
      end
      it 'is false if completed' do
        expect(completed_report.archived?).to be_false
      end
      it 'is false if pending' do
        expect(pending_report.archived?).to be_false
      end
      it 'is false if rejected' do
        expect(rejected_report.archived?).to be_false
      end
    end

    describe '#completed?' do
      it 'is false if accepted' do
        expect(accepted_report.completed?).to be_false
      end
      it 'is false if archived' do
        expect(archived_report.completed?).to be_false
      end
      it 'is true if completed' do
        expect(completed_report.completed?).to be_true
      end
      it 'is false if pending' do
        expect(pending_report.completed?).to be_false
      end
      it 'fales if rejected' do
        expect(rejected_report.completed?).to be_false
      end
    end

    describe '#archived_or_completed?' do
      it 'is false if accepted' do
        expect(accepted_report.archived_or_completed?).to be_false
      end
      it 'is true if archived' do
        expect(archived_report.archived_or_completed?).to be_true
      end
      it 'is true if completed' do
        expect(completed_report.archived_or_completed?).to be_true
      end
      it 'is false if pending' do
        expect(pending_report.archived_or_completed?).to be_false
      end
      it 'is false if rejected' do
        expect(rejected_report.archived_or_completed?).to be_false
      end
    end

  end

  describe '#complete!' do
    it 'completes attributes' do
      report = create(:report)
      report.complete!
      expect(report.status).to eq('completed')
    end
  end

  describe '#set_completed!' do
    # Use update_attribute to not trigger callbacks that occur around validation
    it 'rejects pending responders' do
      report = create(:report, :pending)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.dispatches.sample.status).to eq('rejected')
    end

    it 'completes the accepted responders' do
      report = create(:report, :accepted)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.dispatches.sample.status).to eq('completed')
    end

    it 'sets completed time' do
      report = create(:report)
      report.update_attribute(:status, 'completed')
      report.set_completed!
      expect(report.completed_at).to be < Time.now
    end
  end
end
