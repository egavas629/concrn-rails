require 'spec_helper'

describe Dispatcher do
  it { should belong_to(:user).class_name(User) }
  it { should validate_presence_of(:agency) }
end
