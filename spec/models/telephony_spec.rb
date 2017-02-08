require 'spec_helper'

describe Telephony do
  describe '#client'
  describe '#send'
  
  describe '.receive' do
    let(:responder) { build(:user, :responder, phone: '6665554444', name: 'Roy the Responder') }

    context 'when from a responder' do
      let(:opts) { {from: responder.phone, body: 'Testing'} }

      before do
        allow(Responder).to receive(:find_by_phone).with('6665554444').and_return(responder)
      end

      it "creates an instance of DispatchMessenger with the responder" do
        dispatch_messenger = double(:dispatch_messenger)
        expect(dispatch_messenger).to receive(:respond).with('Body')
        expect(DispatchMessenger).to receive(:new).with(responder).and_return(dispatch_messenger)
        Telephony.receive('Body', opts)
      end
    end


    context 'when from a reporter' do
      let(:opts) { {from: '1234567890', body: 'Testing'}}

      it "texts the backup sms phone" do
        expect(Telephony).to receive(:send).with('1234567890: Testing', to:Rails.configuration.backup_sms_phone)
        Telephony.receive('Body', opts)
      end
    end

  end
end
