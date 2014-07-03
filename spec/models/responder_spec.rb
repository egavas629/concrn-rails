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
    before { responder.shifts(true) }

    describe 'default scope' do
      subject(:all_responders) { Responder.all }

      it 'excludes dispatchers' do
        expect(all_responders).to_not include(dispatcher)
      end

      it 'includes all responders' do
        expect(all_responders).to include(responder, responder_off, responder_inactive)
      end
    end

    describe '.active' do
      subject(:active_responders) { Responder.active }

      it 'excludes inactive responders' do
        expect(active_responders).to_not include(responder_inactive)
      end
      it 'includes active responders' do
        expect(active_responders).to include(responder, responder_off)
      end
    end

    describe '.inactive' do
      subject(:inactive_responders) { Responder.inactive }

      it 'includes inactive responders' do
        expect(inactive_responders).to match_array([responder_inactive])
      end
      it 'excludes active responders' do
        expect(inactive_responders).to_not include(responder, responder_off)
      end
    end

    describe '.on_shift' do
      subject(:on_shift_responders) { Responder.on_shift }

      it 'excludes responders that are not off shift/inactive' do
        expect(on_shift_responders).to_not include(responder_off, responder_inactive)
      end

      it 'includes shifted in responders' do
        expect(on_shift_responders).to match_array([responder])
      end
    end

    describe '.available' do
      subject(:available_responders) { Responder.available }

      it 'excludes accepted/pending responders' do
        responder_pending  = create(:report, :pending).responders[0]
        responder_accepted = create(:report, :accepted).responders[0]
        expect(available_responders).to_not include(responder_pending, responder_accepted)
      end

      it 'excludes shifted-out/inactive responders' do
        expect(available_responders).to_not include(responder_off, responder_inactive)
      end
      it 'includes shifted-in unassigned responders' do
        expect(available_responders).to match_array([responder])
      end
    end

  end

  describe '.accepted' do
    subject(:report)              { create(:report, :accepted) }
    subject(:responder)           { responder = report.dispatches.find_by_status('accepted').responder }
    subject(:responder_two)       { create(:responder, :on_shift) }
    subject(:responder_three)     { create(:responder, :on_shift) }
    subject(:accepted_responders) { Responder.accepted(report.id)}
    before { report.dispatch!(responder_two) }

    it 'excludes pending/unassigned responders' do
      expect(accepted_responders).to_not include(responder_two, responder_three)
    end

    it 'includes accepted/completed responders' do
      expect(accepted_responders).to match_array([responder])
    end
  end

  # Instance methods
  describe '#phone=' do
    subject(:responder) { create(:responder, phone: '555 555 5551gsas') }

    it 'does not accept letters' do
      expect(responder.phone).to eq('5555555551')
    end
  end

  describe '#set_password' do
    subject(:responder) { build(:responder, password: nil, password_confirmation: nil) }
    before { responder.set_password }

    it 'sets the password' do
      expect(responder.password).to eq('password')
    end
    it 'sets the password_confirmation' do
      expect(responder.password_confirmation).to eq('password')
    end
  end

  # Private
  describe '#make_unavailable!' do
    subject(:responder) { create(:responder, :on_shift) }
    before do
      responder.active = false
      responder.send(:make_unavailable!)
    end

    it 'shifts out when inactive' do
      expect(responder.shifts.started?).to be_false
    end
  end
end
