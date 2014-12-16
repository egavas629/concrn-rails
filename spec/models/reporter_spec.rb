require 'spec_helper'

describe Reporter do
  it { should belong_to(:user).class_name(User) }
end
