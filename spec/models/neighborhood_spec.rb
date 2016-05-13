require 'spec_helper'

describe Neighborhood do
  describe '#at' do
    let(:mock_client) { double(:mock_client, spots: [mock_spot]) }
    let(:mock_spot) { double(:spot, vicinity: 'Manhattan') }
    let(:empty_client) { double(:empty_client, spots: []) }
    
    context 'when Google finds nearby spots' do
      it 'asks Google for the vicinity of the coordinates' do
        expect(Neighborhood.at(0,0, mock_client)).to eq 'Manhattan'
      end
    end
    
    context 'when Google finds no spots' do  
      it 'returns nil' do
        expect(Neighborhood.at(420,420, empty_client)).to eq nil
      end
    end

    context 'when passed bad lat/long' do
      it 'returns nil' do
        expect(Neighborhood.at(420,nil, mock_client)).to eq nil
        expect(Neighborhood.at(nil,420, mock_client)).to eq nil
        expect(Neighborhood.at(nil,nil, mock_client)).to eq nil
      end
    end
  end
end