require 'spec_helper'

describe Report do
  it { should have_many(:dispatches).dependent(:destroy) }
  it { should have_many(:logs).dependent(:destroy) }
  it { should have_many(:responders).through(:dispatches) }

  describe 'scopes' do
    let(:report)           { create(:report) }
    let(:accepted_report)  { create(:report, :accepted) }
    let(:archived_report)  { create(:report, :archived) }
    let(:completed_report) { create(:report, :completed) }
    let(:pending_report)   { create(:report, :pending) }
    let(:rejected_report)  { create(:report, :rejected) }

    describe '.accepted' do
      subject { Report.accepted }
      it { should include(accepted_report) }
      it { should_not include(report, archived_report, pending_report, rejected_report) }
    end
    describe '.completed' do
      subject { Report.completed }
      it { should include(completed_report, archived_report) }
      it { should_not include(report, accepted_report, pending_report, rejected_report) }
    end
    describe '.pending' do
      subject { Report.pending }
      it { should include(pending_report) }
      it { should_not include(report, accepted_report, archived_report, completed_report, rejected_report) }
    end
    describe '.unassigned' do
      subject { Report.unassigned }
      it { should include(rejected_report, report) }
      it { should_not include(accepted_report, archived_report, completed_report, pending_report) }
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

  context 'new report' do
    subject { create(:report) }
    its(:current_status) { should eq('unassigned') }
  end

  context 'accepted report' do
    subject { create(:report, :accepted) }
    its(:accepted?)              { should be_true }
    its(:archived?)              { should be_false }
    its(:archived_or_completed?) { should be_false }
    its(:completed?)             { should be_false }
    its(:current_status)         { should eq('active') }
    its(:current_pending?)       { should be_false }

    it 'is false if accepted & pending' do
      subject.dispatch!(create(:responder, :on_shift))
      expect(subject.current_pending?).to be_false
    end
  end

  context 'archived report' do
    subject { create(:report, :archived) }
    its(:archived?)              { should be_true }
    its(:archived_or_completed?) { should be_true }
    its(:completed?)             { should be_false}
    its(:current_status)         { should eq('archived') }
  end

  context 'completed report' do
    subject { create(:report, :completed).reload }
    its(:archived?)              { should be_false }
    its(:archived_or_completed?) { should be_true }
    its(:completed?)             { should be_true }
    its(:current_status)         { should eq('completed') }
  end

  context 'pending report' do
    subject { create(:report, :pending) }
    its(:accepted?)              { should be_false }
    its(:archived?)              { should be_false }
    its(:archived_or_completed?) { should be_false }
    its(:completed?)             { should be_false }
    its(:current_pending?)       { should be_true }
    its(:current_status)         { should eq('pending') }
  end

  context 'rejected report' do
    subject { create(:report, :rejected) }
    its(:accepted?)              { should be_false }
    its(:archived?)              { should be_false }
    its(:archived_or_completed?) { should be_false }
    its(:completed?)             { should be_false }
    its(:current_pending?)       { should be_false }
    its(:current_status)         { should eq('unassigned') }
  end

  describe '#complete!' do
    subject { create(:report) }
    before  { subject.complete! }
    its(:status) { should eq('completed') }
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
