module UserSessionHelper
  def current_user
    @current_user
  end

  def login(user=nil)
    @current_user = user || FactoryGirl.create(:dispatcher)

    visit '/'
    fill_in 'email', with: @current_user.email
    fill_in 'password', with: 'password'

    click_button 'Login'
    expect(page).to have_content('Logout')
  end

  def logout
    click_link 'Logout'
  end

  def step_away_to
    initial_location = page.current_url
    yield
    visit initial_location if initial_location
  end
end

RSpec.configure do |config|
  config.include UserSessionHelper
end if RSpec.respond_to?(:configure)

World(UserSessionHelper) if respond_to?(:World)
