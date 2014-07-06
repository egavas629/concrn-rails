require 'spec_helper'

describe Log do
  let(:time) { Time.now.utc }
  it { should belong_to(:report) }
  it { should belong_to(:author).class_name('User') }
  it { should delegate_method(:author_role).to(:author).as(:role) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:report) }

  describe 'default scope order by #created_at ASC' do
    let(:logs)       { create_list(:log, 3, report: report) }
    let(:log_one)    { logs[0] }
    let(:log_two)    { logs[1].update_attribute(:created_at, time + 5.minutes);logs[1] }
    let(:log_three)  { logs[2].update_attribute(:created_at, time + 3.minutes);logs[2] }
    subject(:report) { create(:report, :accepted) }
    before           { Dispatch.any_instance.stub(:messanger) }
    its(:logs)       { should match_array([log_one, log_three, log_two]) }
  end

  describe '#broadcast' do
    subject { create(:log) }

    context 'no accepted responders' do
      before do
        Responder.accepted(subject.report.id).destroy_all
        subject.broadcast
      end

      its(:sent_at) { should be_nil }
    end

    context 'accepted responders present' do
      before    { subject.broadcast }
      its('sent_at.day') { should eq(time.day) }
    end
  end

  describe '#broadcasted?' do
    context 'sent_at present' do
      subject { create(:log, sent_at: time) }
      its(:broadcasted?) { should be_true }
    end

    context 'sent_at empty' do
      subject { create(:log) }
      its(:broadcasted?) { should be_false }
    end
  end

  describe '#refresh_report' do
    context 'after_commit' do
      subject { build(:log) }
      it 'triggers' do
        expect(subject).to receive(:refresh_report)
        subject.save
      end
    end
  end
end
