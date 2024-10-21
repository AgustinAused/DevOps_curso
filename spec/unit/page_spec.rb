require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

include Capybara::DSL
Capybara.app_host = "http://website"  # URL del sitio a probar
Capybara.run_server = false  # No necesitamos Rack porque usamos Selenium para conectarnos al servidor externo.

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-default-browser-check')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
    options: options  
  )
end

Capybara.default_driver = :selenium

describe "Example page render unit tests" do
  it "Shows the Explore California logo" do
    visit('/')
    expect(page).to have_selector('.logo') 
  end
end
