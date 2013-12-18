require 'spec_helper'

describe Dispatch do
  describe 'scopes' do
    describe '.not_rejected' do
      it 'returns dispatches whose status is anything but "rejected"' do
        new_dispatch = create :dispatch
        accepted_dispatch = create :dispatch, :accepted
        create :dispatch, :rejected

        Dispatch.not_rejected.pluck(:id).should =~ [accepted_dispatch, new_dispatch].map(&:id)
      end
    end
  end
end
