require 'spec_helper'

describe Log do
  let(:log) { create :log }

  # describe '#broadcast' do
  #   let(:responder_phone) { log.report.accepted_responders.first.phone }
  #
  #   it 'sends the body as SMS to the related responder' do
  #     expect(Telephony).to receive(:send).with log.body, to: responder_phone
  #     log.broadcast
  #   end
  # end
end
