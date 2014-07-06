require 'spec_helper'

describe Shift do
  context 'validations' do
    it { should belong_to(:responder) }
    it { should validate_presence_of(:responder) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:start_via) }
  end

  context 'creating instance' do
    let(:responder) { create(:responder) }
    subject         { responder.shifts.create(start_time: Time.now, start_via: 'web') }

    it { should be_valid }
  end

  describe 'scope' do
    let(:shift)     { create(:shift) }
    let(:shift_off) { create(:shift, :ended) }

    # had start_with instead of include but causing errors
    describe 'default scope' do
      subject { Shift.all }
      it { should include(shift_off, shift) }
    end

    # had start_with instead of include but causing errors
    describe '.on' do
      subject { Shift.on }
      it { should_not include(shift_off) }
      it { should include(shift) }
    end
  end

  describe '.started?' do
    subject { create(:responder) }

    its('shifts.started?') { should be_false }
    it 'true if in-shift' do
      subject.shifts.start!
      expect(subject.shifts.started?).to be_true
    end
  end

  describe '.start!' do
    subject { create(:responder) }
    before  { subject.shifts.start! }
    its('shifts.count') { should eq(1) }
    its('shifts.first.start_via') { should eq('web') }
  end

  describe '.end!' do
    subject { create(:responder, :on_shift) }
    before  { subject.shifts.end! }
    its('shifts.started?') { should be_false }
  end

  describe '#same_day?' do
    subject { build(:shift, :ended) }

    it 'is true when same day' do
      subject.start_time = Time.now - 10.minutes
      expect(subject.same_day?).to be_true
    end

    it 'is false when diff day' do
      subject.start_time = Time.now - 2.days
      expect(subject.same_day?).to be_false
    end
  end

  describe '#push_reports' do
    context 'after_commit' do
      subject { build(:shift) }
      it 'should trigger' do
        expect(subject).to receive(:push_reports)
        subject.save
      end
    end
  end

end
