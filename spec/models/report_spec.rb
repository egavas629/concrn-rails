require 'spec_helper'

describe Report do
  it { should belong_to(:agency) }
  it { should have_many(:dispatches).dependent(:destroy) }
  it { should have_many(:logs).dependent(:destroy) }
  it { should have_many(:responders).through(:dispatches) }
  it { should validate_presence_of(:address) }
  it { should ensure_inclusion_of(:status).in_array(Report::STATUS) }
  it { should ensure_inclusion_of(:gender).in_array(Report::GENDER).allow_blank(true) }
  it { should ensure_inclusion_of(:age).in_array(Report::AGEGROUP).allow_blank(true) }
  it { should ensure_inclusion_of(:race).in_array(Report::ETHNICITY).allow_blank(true) }
  it { should ensure_inclusion_of(:setting).in_array(Report::SETTING).allow_blank(true) }
  it { should have_attached_file(:image) }

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

    it 'is run before_validation' do
      expect(report).to receive(:clean_image).once
      report.valid?
    end

    context 'delete_image is true' do
      before do
        report.delete_image = '1'
        report.send(:clean_image)
      end
      its('image.url') { should eq("/images/original/missing.png") }
    end

    context 'delete_image is false' do
      before do
        report.delete_image = '0'
        report.send(:clean_image)
      end
      its('image.url') { should_not eq("/images/original/missing.png") }
    end
  end

  describe '#clean_observations' do
    subject(:report) { build(:report) }

    it 'is run before_validation' do
      expect(report).to receive(:clean_observations).once
      report.valid?
    end

    context 'array present' do
      before do
        report.observations = ['Agitated', '', 'Hungry', nil]
        report.send(:clean_observations)
      end
      its(:observations) { should match_array(['Agitated', 'Hungry']) }
    end

    context 'array empty' do
      before do
        report.observations = ['', nil]
        report.send(:clean_observations)
      end
      its(:observations) { should match_array([]) }
    end

  end

  describe 'state methods' do
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

      context 'with pending dispatch' do
        before { subject.dispatch!(create(:responder, :on_shift)) }
        its(:current_pending?) { should be_false }
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
  end

  describe '#complete!' do
    subject { create(:report) }
    before  { subject.complete! }
    its(:status) { should eq('completed') }
  end

  describe '#set_completed!' do
    context 'after_validation triggered' do
      subject { create(:report) }

      context 'report completed' do
        before { subject.status = 'completed' }
        it 'runs' do
          expect(subject).to receive(:set_completed!).once
          subject.valid?
        end
      end

      context 'report archived' do
        before { subject.status = 'archived' }
        it 'runs' do
          expect(subject).to receive(:set_completed!).once
          subject.valid?
        end
      end

      context 'report pending' do
        before { subject.status = 'pending' }
        it 'doesn\'t run' do
          expect(subject).to_not receive(:set_completed!)
          subject.valid?
        end
      end
    end

    context 'pending responders' do
      subject { create(:report, :pending) }
      before do
        subject.update_column(:status, 'completed')
        subject.set_completed!
      end
      its('dispatches.sample.status') { should eq('rejected') }
    end

    context 'accepted responders' do
      subject { create(:report, :accepted) }
      before do
        subject.update_column(:status, 'completed')
        subject.set_completed!
      end
      its('dispatches.sample.status') { should eq('completed') }
    end

    context 'after' do
      subject { create(:report) }
      before do
        subject.update_column(:status, 'completed')
        subject.set_completed!
      end
      its(:completed_at) { should be < Time.now }
    end
  end

  describe '#push_reports' do
    context 'after_commit' do
      subject { build(:report) }
      it 'should trigger' do
        expect(subject).to receive(:push_reports)
        subject.save
      end
    end
  end
end
