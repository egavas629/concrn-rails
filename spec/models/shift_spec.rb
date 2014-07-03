require 'spec_helper'

describe Shift do
  it { should belong_to(:responder) }
  it { should validate_presence_of(:responder) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:start_via) }

  context 'creating instance' do
    subject(:shift) do
      responder = create(:responder)
      responder.shifts.create(
        start_time: Time.now,
        start_via: 'web'
      )
    end

    it 'is valid with a responder, start_time, and start_via' do
      expect(shift).to be_valid
    end
  end

  describe 'scope' do
    subject(:shift)     { create(:shift) }
    subject(:shift_off) { create(:shift, :ended) }
    before do
      shift.reload
      shift_off.reload
    end

    describe 'default scope' do
      subject(:shifts) { Shift.all }

      it 'shows in descending start_time order' do
        expect(shifts).to match_array([shift, shift_off])
      end
    end

    describe '.on' do
      subject(:shift_on) { Shift.on }

      it 'excludes shifted out responders' do
        expect(shift_on).to_not include(shift_off)
      end

      it 'includes shifted in responders' do
        expect(shift_on).to match_array([shift])
      end
    end
  end

  describe '.started?' do
    subject(:responder) { create(:responder) }

    it 'true if in-shift' do
      responder.shifts.start!
      expect(responder.shifts.started?).to be_true
    end

    it 'is false if not in-shift' do
      expect(responder.shifts.started?).to be_false
    end
  end

  describe '.start!' do
    subject(:responder) { create(:responder) }
    before { responder.shifts.start! }

    it 'creates a shift' do
      expect(responder.shifts.started?).to be_true
    end
  end
  describe '.end!' do
    subject(:shift)     { create(:shift) }
    subject(:responder) { shift.responder}
    before { responder.shifts.end! }

    it 'ends a shift' do
      expect(responder.shifts.started?).to be_false
    end
  end

  describe '#same_day?' do
    subject(:shift) { build(:shift, :ended) }

    it 'is true when same day' do
      shift.start_time = Time.now - 10.minutes
      expect(shift.same_day?).to be_true
    end

    it 'is false when diff day' do
      shift.start_time = Time.now - 2.days
      expect(shift.same_day?).to be_false
    end
  end

end
