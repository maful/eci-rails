require 'fileutils'
require 'shellwords'

def add_template_repository_to_source_path
  source_paths.unshift(File.dirname(__FILE__))
end

def add_gems
  gem 'devise'
end

def rails_version

end

def rails_5?

end

def set_application_name

end

def add_users

end

def copy_template

end

def add_webpacker

end

def add_javascript

end

def setup_tailwindcss

end

add_template_repository_to_source_path

add_gems

after_bundle do
  set_application_name

  add_users

  add_webpacker

  add_javascript

  setup_tailwindcss

  # Commit everything to git
  git :init
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
end
