require 'spec_helper'

describe Dispatch do
  context 'when created' do
    it 'sends all the synopses to the responder' do
      create :dispatch
      expect(Telephony).to receive(:send).exactly(5).times
    end
  end
end
