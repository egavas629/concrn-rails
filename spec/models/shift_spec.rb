require 'spec_helper'

describe Shift do
  it { should belong_to(:responder) }
  it { should validate_presence_of(:responder) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:start_via) }

  describe 'default scope'
  describe '.on'
  describe '.started?'
  describe '.start!'
  describe '.end!'
  describe '#same_day?'
  # Private
  describe '#refresh_responders'
end
