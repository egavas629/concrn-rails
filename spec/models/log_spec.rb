require 'spec_helper'

describe Log do
  it { should belong_to(:report) }
  it { should belong_to(:author).class_name('User') }
  it { should delegate_method(:author_role).to(:author).as(:role) }

  describe 'default scope'
  describe '#broadcast'
  describe '#broadcasted?'

  # describe '#broadcast' do
  #   let(:responder_phone) { log.report.accepted_responders.first.phone }
  #
  #   it 'sends the body as SMS to the related responder' do
  #     expect(Telephony).to receive(:send).with log.body, to: responder_phone
  #     log.broadcast
  #   end
  # end
end
