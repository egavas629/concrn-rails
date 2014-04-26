require 'spec_helper'

describe Log do
  let(:log) { create :log }

  describe '#broadcast' do
    let(:responder_phone) { log.report.responder.phone }

    it 'sends the body as SMS to the related responder' do
      expect(Message).to receive(:send).with log.body, to: responder_phone
      log.broadcast
    end
  end
end
