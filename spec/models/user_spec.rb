require 'spec_helper'

describe User do
  it { should belong_to(:agency) }
  it { should validate_presence_of(:agency) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:agency_id) }
  it { should validate_presence_of(:phone) }
  it { should validate_uniqueness_of(:phone) }
  it { should ensure_inclusion_of(:role).in_array(User::ROLES) }

  context 'scopes' do
    let!(:responder)  { create(:user, :responder) }
    let!(:dispatcher) { create(:user, :dispatcher) }
    let!(:inactive_responder)  { create(:user, :responder, active: false) }
    let!(:inactive_dispatcher) { create(:user, :dispatcher, active: false) }

    describe '.active' do
      subject { User.active }

      it { should_not include(inactive_responder, inactive_dispatcher) }
      it { should include(responder, dispatcher) }
    end

    describe '.inactive' do
      subject { User.inactive }

      it { should include(inactive_responder, inactive_dispatcher) }
      it { should_not include(responder, dispatcher) }
    end
  end

  describe '#dispatcher?' do
    context 'responder' do
      subject { build(:user, :responder) }
      its(:dispatcher?) { should be_false }
    end

    context 'dispatcher' do
      subject { build(:user, :dispatcher) }
      its(:dispatcher?) { should be_true }
    end
  end

  describe '#responder?' do
    context 'responder' do
      subject { build(:user, :responder) }
      its(:responder?) { should be_true }
    end

    context 'dispatcher' do
      subject { build(:user, :dispatcher) }
      its(:responder?) { should be_false }
    end
  end

  describe '#phone=' do
    subject     { build(:user, phone: '555 555 5551gsas') }
    its(:phone) { should eq('5555555551') }
  end

  # describe '#become_child' do
  #   context 'responder' do
  #     subject { build(:user, :responder) }
  #     its(:become_child) { should be_instance_of(Responder) }
  #   end
  #
  #   context 'dispatcher' do
  #     subject { build(:user, :dispatcher) }
  #     its(:become_child) { should be_instance_of(Dispatcher) }
  #   end
  # end
end
