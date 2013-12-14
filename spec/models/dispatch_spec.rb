require 'spec_helper'

describe Dispatch do
  describe 'scopes' do
    describe 'not_rejected' do
      it 'returns dispatches whose status is anything but "rejected"' do
        create :dispatch
        create :dispatch, :accepted
        create :dispatch, :rejected
        Dispatch.not_rejected.should =~ [accepted_dispatch, new_dispatch]
      end
    end
  end
end
