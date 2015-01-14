require 'spec_helper'

describe Upload do
  it { should have_attached_file(:file) }
end
