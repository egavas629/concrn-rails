require 'spec_helper'

describe Shift do
  it { should belong_to(:responder) }
  it { should validate_presence_of(:responder) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:start_via) }

  describe 'scope' do
    subject(:shift)     { create(:shift) }
    subject(:shift_off) { create(:shift, :ended) }

    describe 'default scope' do
      it 'shows in descending start_time order' do
        first, second = Shift.all[0], Shift.all[1]
        expect(first.start_time).to be > second.start_time
      end
    end

    describe '.on' do
      it 'should not show shifted out responders' do
        expect(Shift.on).to_not include(shift_off)
      end

      it 'should show shifted in responders' do
        expect(Shift.on).to include(shift)
      end
    end
  end

  describe '.started?' do
    it 'should be true if shift started' do
      shift = create(:shift)
      expect(shift.responder.shifts.started?).to be_true
    end

    it 'should be false if shift not-started' do
      responder = create(:responder)
      expect(responder.shifts.started?).to be_false
    end
  end
  describe '.start!' do
    it 'should create a shift' do
      responder = create(:responder)
      expect(responder.shifts.count).to eq(0)
      responder.shifts.start!
      expect(responder.shifts.count).to eq(1)
      expect(responder.shifts.started?).to be_true
    end
  end
  describe '.end!' do
    it 'should end a shift' do
      shift     = create(:shift)
      responder = shift.responder
      expect(responder.shifts.started?).to be_true
      responder.shifts.end!
      expect(responder.shifts.started?).to be_false
    end
  end

  describe '#same_day?' do
    it 'should be true when same day' do
      shift     = create(:shift, start_time: Time.now)
      responder = shift.responder
      responder.shifts.end!
      expect(responder.shifts.first.same_day?).to be_true
    end

    it 'should be false when diff day' do
      shift     = create(:shift)
      responder = shift.responder
      responder.shifts.end!
      expect(responder.shifts.first.same_day?).to be_false
    end
  end

  # Private
  describe '#refresh_responders'
end
