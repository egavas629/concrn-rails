require 'spec_helper'

describe Responder do
  it { should have_many(:dispatches).dependent(:destroy) }
  it { should have_many(:shifts).dependent(:destroy) }
  it { should have_many(:reports).through(:dispatches) }

  # Scopes
  describe 'scopes' do
    subject(:responder)           { create(:responder, :on_shift) }
    subject(:responder_off)       { create(:responder) }
    subject(:responder_inactive)  { create(:responder, active: false) }
    subject(:dispatcher)          { create(:dispatcher) }

    describe 'default scope' do
      it 'should exclude dispatchers' do
        expect(Responder.all).to_not include(dispatcher)
      end

      it 'should include all responders' do
        expect(Responder.all).to include(responder, responder_off, responder_inactive)
      end
    end

    describe '.active' do
      it 'should exclude inactive responders' do
        expect(Responder.active).to_not include(responder_inactive)
      end

      it 'should only show active responders' do
        expect(Responder.all).to include(responder, responder_off)
      end
    end

    describe '.inactive' do
      it 'should include inactive responders' do
        expect(Responder.inactive).to match_array([responder_inactive])
      end

      it 'should exclude active responders' do
        expect(Responder.inactive).to_not include(responder, responder_off)
      end
    end

    describe '.on_shift' do
      it 'should exclude responders that are not off shift/inactive' do
        expect(Responder.on_shift).to_not include(responder_off, responder_inactive)
      end

      it 'should include shifted in responders' do
        # Unsure why I need the below link to make the test pass?
        responder.shifts.started?
        expect(Responder.on_shift).to include(responder)
      end
    end

    describe '.available' do
      it 'should exclude accepted/pending responders' do
        responder_pending  = create(:report, :pending).responders[0]
        responder_accepted = create(:report, :accepted).responders[0]
        expect(Responder.available).to_not include(responder_pending, responder_accepted)
      end

      it 'should exclude shifted-out/inactive responders' do
        expect(Responder.available).to_not include(responder_off, responder_inactive)
      end

      it 'should include shifted-in unassigned responders' do
        # Unsure why I need the below link to make the test pass?
        responder.shifts.started?
        expect(Responder.available).to include(responder)
      end
    end

  end

  # Class methods
  describe '.accepted' do
    subject(:report)          { create(:report, :accepted) }
    subject(:responder)       { responder = report.dispatches.where(status: 'accepted')[0].responder }
    subject(:responder_two)   { create(:responder, :on_shift) }
    subject(:responder_three) { create(:responder, :on_shift) }
    before { report.dispatch!(responder_two) }

    it 'should exclude pending/unassigned responders' do
      expect(Responder.accepted(report.id)).to_not include(responder_two, responder_three)
    end

    it 'should include accepted/completed responders' do
      expect(Responder.accepted(report.id)).to include(responder)
    end
  end

  # Instance methods
  describe '#phone=' do
    it 'does not accept letters' do
      responder = create(:responder, phone: '555 555 5551gsas')
      expect(responder.phone).to eq('5555555551')
    end
  end

  describe '#set_password' do
    it 'sets the password' do
      responder = build(:responder, password: nil, password_confirmation: nil)
      expect(responder.password).to eq(nil)
      responder.set_password
      expect(responder.password).to eq('password')
      expect(responder.password_confirmation).to eq('password')
    end
  end

  # Private
  describe '#make_unavailable!' do
    subject(:responder) { create(:responder, :on_shift) }
    it 'should shift out when inactive' do
      responder.active = false
      responder.send(:make_unavailable!)
      expect(responder.shifts.started?).to be_false
    end
  end

  describe '#push_reports'
end
