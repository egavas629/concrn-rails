require 'spec_helper'

describe LogsController do
  describe '#create' do
    let(:params) do
      {"log"=>{"body"=>expected_content, "author_id"=>"6", "report_id"=>"1"}}
    end
    let(:expected_content) { 'A man, a plan, a hat, a boat, a canal, a Panamanian' }
    let(:request) { post :create, params }

    it 'creates a log' do
      -> { request }.should change(Log, :count).by(1)
      Log.last.body.should == expected_content
    end
  end
end
