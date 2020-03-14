require 'fileutils'
require 'shellwords'

RAILS_REQUIREMENT = "~> 6.0.0".freeze

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("eci-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
        "--quiet",
        "https://github.com/maful/eci-rails.git",
        tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{eci/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def add_gems
  gem 'devise', '~> 4.7', '>= 4.7.1'
  gem 'font-awesome-sass', '~> 5.12.0'
  gem 'friendly_id', '~> 5.2', '>= 5.2.5'
  gem 'gravatar_image_tag', '~> 1.2'
  gem 'mini_magick', '~> 4.9', '>= 4.9.2'
  gem 'name_of_person', '~> 1.1'
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.module_parent_name"

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

def setup_routes
  route "root to: 'home#index'"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Generate views
  generate "devise:views"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name"

  # Set devise secret key
  if Gem::Requirement.new("> 5.2").satisfied_by? rails_version
    gsub_file "config/initializers/devise.rb",
              /  # config.secret_key = .+/,
              "  config.secret_key = Rails.application.credentials.secret_key_base"
  end
end

def add_javascript
  run "yarn add tailwindcss @fullhuman/postcss-purgecss"
end

def setup_tailwindcss
  # Update postcss.config.js
  content_import = <<-JS
    require('tailwindcss'),
    require('autoprefixer'),
  JS

  insert_into_file "postcss.config.js", content_import, before: "require('postcss-import'),"
  gsub_file "postcss.config.js", /module.exports = {/, "let environment = {"

  content_purgecss = <<-JS
if (process.env.RAILS_ENV === "production") {
  environment.plugins.push(
    require('@fullhuman/postcss-purgecss')({
      content: ['./app/**/*.html.erb', './app/helpers/**/*.rb'],
      defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
    })
  )
}

module.exports = environment
  JS

  append_to_file "postcss.config.js", "\n#{content_purgecss}"

  # Create tailwind.config.js
  copy_file "tailwind.config.js"
end

def copy_templates
  remove_file "app/assets/stylesheets/application.css"

  copy_file "Procfile"
  copy_file "Procfile.dev"
  copy_file ".foreman"

  directory "app", force: true
  directory "config", force: true
end

def add_posts
  generate "model Post user:references title description:text slug:uniq:index"
  route "resources :posts"

  content = <<-RUBY
  validates :title, :description, presence: true
  RUBY

  insert_into_file "app/models/post.rb", "\n#{content}", after: "class Post < ApplicationRecord"
end

def add_friendly_id
  content = <<-RUBY
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  RUBY

  insert_into_file "app/models/post.rb", "\n#{content}", after: "class Post < ApplicationRecord"
end

def stop_spring
  run "spring stop"
end

def preexisting_git_repo?
  @preexisting_git_repo ||= (File.exist?(".git") || :nope)
  @preexisting_git_repo == true
end

# Main setup
assert_minimum_rails_version

add_template_repository_to_source_path

add_gems

after_bundle do
  set_application_name
  stop_spring
  setup_routes
  add_users
  # Rails 6+ comes with webpacker by default
  add_javascript
  setup_tailwindcss
  add_posts
  add_friendly_id
  copy_templates

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  # Commit everything to git
  git :init unless preexisting_git_repo?
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }

  say
  say "Eci app successfully created!", :green
  say
  say "To get started with your amazing app:"
  say "cd #{app_name} - Move to your amazing app directory."
  say "foreman start - Run Rails and webpack-dev-server."
end
