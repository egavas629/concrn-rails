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

  context '#time_zone' do
    let!(:agency)  { create(:agency) }

    describe 'one zip_code' do
      subject { create(:agency, zip_code_list: "78702") }
      its(:time_zone) { should eq 'Central Time (US & Canada)' }
    end

    describe 'comma seperated zips' do
      subject { create(:agency, zip_code_list: "78702, 89767") }
      its(:time_zone) { should eq 'Central Time (US & Canada)' }
    end

    describe 'space seperated zips' do
      subject { create(:agency, zip_code_list: "78702 89767") }
      its(:time_zone) { should eq 'Central Time (US & Canada)' }
    end
  end

end
