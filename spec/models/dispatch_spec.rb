require 'spec_helper'

describe Dispatch do
  describe '.not_rejected' do
    it 'returns dispatches with status other than "rejected"' do
      new_dispatch = create :dispatch
      accepted_dispatch = create :dispatch, :accepted
      create :dispatch, :rejected

      p Dispatch.pluck(:status)
      Dispatch.not_rejected.should =~ [accepted_dispatch, new_dispatch]
    end
  end
end