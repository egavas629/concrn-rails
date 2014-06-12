require 'spec_helper'

describe Dispatch do
  context 'when created' do
    it 'sends all the synopses to the responder' do
      expect(Message).to receive(:send).exactly(5).times
      create :dispatch
    end
  end
end
