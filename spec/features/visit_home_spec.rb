require 'rails_helper'

feature 'Visit Home Page' do
  background do
    visit '/'
  end

  scenario 'Title: ECI Rails Template' do
    expect(page).to have_content('ECI Rails Template')
  end

  scenario 'Verify Link Exists: Sign In' do
    expect(page).to have_link('Sign In')
  end

  scenario 'Click Link: Sign In ==> Navigate to /users/sign_in' do
    click_link('Sign In')
    expect(page).to have_current_path('/users/sign_in')
  end

  scenario 'Verify Link Exists: Sign Up' do
    expect(page).to have_link('Sign Up')
  end

  scenario 'Click Link: Sign Up ==> Navigate to /users/sign_up' do
    click_link('Sign Up')
    expect(page).to have_current_path('/users/sign_up')
  end
end