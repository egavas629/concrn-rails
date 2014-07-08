require 'spec_helper'

describe User do
  it { should belong_to(:agency) }
  it { should validate_presence_of(:agency) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:agency_id) }
  it { should validate_presence_of(:phone) }
  it { should validate_uniqueness_of(:phone) }
end
