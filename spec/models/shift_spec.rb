require 'spec_helper'

describe Shift do
  it { should belong_to(:responder) }
  it { should validate_presence_of(:responder) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:start_via) }

  describe 'scope' do
    subject(:responder_shifts)       { create(:responder, :on_shift).shifts }
    subject(:responder_two_shifts)   { create(:responder, :on_shift).shifts }
    subject(:responder_three_shifts) { create(:responder, :on_shift).shifts }
    subject(:responder_four_shifts)  { create(:responder).shifts }
    before { responder_three_shifts.end! }

    describe 'default scope' do
      it 'shows in descending start_time order' do
        first, second = Shift.all[0], Shift.all[1]
        expect(first.start_time).to be > second.start_time
      end
    end

    describe '.on' do
      it 'should not show shifted out responders' do
        expect(Shift.on).to_not include(responder_three_shifts.first, responder_four_shifts.first)
      end

      # Unsure why I need count before
      it 'should show shifted in responders' do
        responder_shifts.count
        responder_two_shifts.count
        expect(Shift.on).to include(responder_shifts.first, responder_two_shifts.first)
      end
    end
  end
  describe '.started?' do
    it 'should be true if shift started' do
      responder = create(:responder, :on_shift)
      expect(responder.shifts.started?).to be_true
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
      responder = create(:responder, :on_shift)
      expect(responder.shifts.started?).to be_true
      responder.shifts.end!
      expect(responder.shifts.started?).to be_false
    end
  end

  describe '#same_day?' do
    it 'should be true if on same day' do
      responder = create(:responder, :on_shift)
      responder.shifts.end!
      expect(responder.shifts.first.same_day?).to be_true
    end

    it 'should be false if on diff day' do
      responder = create(:responder, :on_shift)
      responder.shifts.first.update_attribute(:start_time, Time.now - 2.days)
      responder.shifts.end!
      expect(responder.shifts.first.same_day?).to be_false
    end
  end

  # Private
  describe '#refresh_responders'
end
