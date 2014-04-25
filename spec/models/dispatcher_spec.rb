require 'spec_helper'

describe Dispatcher do
  describe '#reports' do
    let(:rangers) { create :agency_with_reports, name: 'rangers' }
    let(:rogues) { create :agency_with_reports, name: 'rogues' }
    let(:ranger) { Dispatcher.new(agency: rangers) }
    let(:rogue) { Dispatcher.new(agency: rogues) }

    it 'is limited to only those belonging to the same agency as the dispatcher' do
      expect(ranger.reports).to_not include(rogue.reports)
    end
  end
end
