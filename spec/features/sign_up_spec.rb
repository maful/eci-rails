require 'rails_helper'

feature 'Sign Up Page: Validate Page Elements' do
  background do
    visit '/users/sign_up'
  end

  scenario 'Displayed Title: Create your account' do
    expect(page).to have_css('h2', text: 'Create your account')
  end

  scenario 'Displayed Textbox: Email' do
    expect(page).to have_field('Email')
  end

  scenario 'Displayed Textbox: Password' do
    expect(page).to have_field('Password')
  end

  scenario 'Displayed Button: Sign up' do
    expect(page).to have_button('Sign up')
  end
end
