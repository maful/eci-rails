require 'rails_helper'

feature 'Sign In Page: Validate Page Elements' do
  background do
    visit '/users/sign_in'
  end

  scenario 'Displayed Title: Sign in to your account' do
    expect(page).to have_css('h2', text: 'Sign in to your account')
  end

  scenario 'Displayed Textbox: Email' do
    expect(page).to have_field('Email')
  end

  scenario 'Displayed Textbox: Password' do
    expect(page).to have_field('Password')
  end

  scenario 'Displayed Button: Sign in' do
    expect(page).to have_button('Sign in')
  end
end
