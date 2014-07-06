require 'spec_helper'

describe Responder do
  it { should have_many(:dispatches).dependent(:destroy) }
  it { should have_many(:shifts).dependent(:destroy) }
  it { should have_many(:reports).through(:dispatches) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:phone) }
  it { should validate_uniqueness_of(:phone) }

  describe 'scopes' do
    let(:time)                { Time.now }
    let(:responder)           { create(:responder, :on_shift, created_at: time - 10.minutes) }
    let(:responder_off)       { create(:responder, created_at: time - 5.minutes) }
    let(:responder_inactive)  { create(:responder, active: false, created_at: time - 3.minutes) }
    let(:dispatcher)          { create(:dispatcher) }

    describe 'default scope' do
      subject { Responder.all }

      it { should_not include(dispatcher) }
      it { should include(responder, responder_off, responder_inactive) }
    end

    describe '.active' do
      subject { Responder.active }

      it { should_not include(responder_inactive) }
      it { should include(responder, responder_off) }
    end

    describe '.inactive' do
      subject { Responder.inactive }

      it { should start_with(responder_inactive) }
      it { should_not include(responder, responder_off) }
    end

    describe '.on_shift' do
      subject { Responder.on_shift }

      it { should_not include(responder_off, responder_inactive) }
      it { should include(responder) }
    end

    describe '.available' do
      subject { Responder.available }

      it { should_not include(responder_off, responder_inactive) }
      it { should include(responder) }

      it 'excludes accepted/pending responders' do
        responder_pending  = create(:report, :pending).responders[0]
        responder_accepted = create(:report, :accepted).responders[0]
        expect(subject).to_not include(responder_pending, responder_accepted)
      end
    end

  end

  describe '.accepted' do
    let(:report)              { create(:report, :accepted) }
    let(:responder)           { responder = report.dispatches.find_by_status('accepted').responder }
    let(:responder_two)       { create(:responder, :on_shift) }
    let(:responder_three)     { create(:responder, :on_shift) }
    subject                   { Responder.accepted(report.id)}
    before                    { report.dispatch!(responder_two) }

    it { should_not include(responder_two, responder_three) }
    it { should start_with(responder) }
  end

  # Instance methods
  describe '#phone=' do
    subject     { create(:responder, phone: '555 555 5551gsas') }
    its(:phone) { should eq('5555555551') }
  end

  describe '#set_password' do
    subject { build(:responder, password: nil, password_confirmation: nil) }
    before  { subject.set_password }

    its(:password) { should eq('password') }
    its(:password_confirmation) { should eq('password') }
  end

  # Private
  describe '#make_unavailable!' do
    let(:responder) { create(:responder, :on_shift) }
    subject         { responder.shifts }

    before do
      responder.active = false
      responder.send(:make_unavailable!)
    end

    its(:started?) { should be_false }
  end

  describe '#push_reports' do
    context 'after_update' do
      subject { create(:responder) }
      before  { subject.name = 'Joe Smith' }
      it 'should trigger' do
        expect(subject).to receive(:push_reports)
        subject.save
      end
    end
  end
end
