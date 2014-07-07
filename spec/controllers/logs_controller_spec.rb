require 'spec_helper'

describe LogsController do
  # describe '#create' do
  #   let(:params) do
  #     {"log"=>{"body"=>expected_content, "author_id"=>"6", "report_id"=>"1"}}
  #   end
  #   let(:expected_content) { 'A man, a plan, a hat, a boat, a canal, a Panamanian' }
  #   let(:request) { post :create, params }
  #
  #   it 'creates a log' do
  #     -> { request }.should change(Log, :count).by(1)
  #     Log.last.body.should == expected_content
  #   end
  # end
  #
  # describe '#update' do
  #   let!(:log) { create :log }
  #   let(:responder_phone) { log.report.accepted_responders.first.phone }
  #   let(:params) { {"id"=>log.to_param} }
  #   let(:request) { put :update, params }
  #
  #   it 'forwards the log body to the appropriate responder' do
  #     Telephony.should_receive(:send).with log.body, to: responder_phone
  #     request
  #   end
  # end
end
