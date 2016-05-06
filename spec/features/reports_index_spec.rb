require 'feature_helper'

describe 'reports index' do
  before do
    login_as(create(:dispatcher), scope: :user)
  end
  
  context 'when there are reports' do
    let!(:reports) { create_list :report, 30 }
    
    it 'shows the latest ten reports' do
      visit '/reports'
      expect(page).to have_selector('tr.report', count: 10)
    end
  end
end