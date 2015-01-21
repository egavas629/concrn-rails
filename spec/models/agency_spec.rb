require 'spec_helper'

describe Agency do
  it { should have_many(:users).dependent(:destroy) }
  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:responders).through(:users) }
  it { should have_many(:dispatchers).through(:users) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:text_phone) }
  it { should validate_presence_of(:call_phone) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:address) }
  it { should validate_uniqueness_of(:text_phone) }
  it { should validate_uniqueness_of(:call_phone) }
  it { should validate_uniqueness_of(:zip_code_list) }

  describe '#time_zone' do
    subject { create(:agency, address: "55555 Roady Rd, Austin, TX  78702-4444") }
    its(:time_zone) { should eq 'Central Time (US & Canada)' }
  end

end
