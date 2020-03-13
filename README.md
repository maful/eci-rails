👉 **Note:** This project under development.

# Eci Rails Template

## Getting Started

#### Features
*   Authentication
*   Webpacker configuration by default
*   [Tailwind CSS](https://tailwindcss.com/) as a CSS framework

#### Roadmap

- [ ] Add OmniAuth
- [ ] Use Tailwind CSS components by default
- [ ] Use Sidekiq for background processing
- [ ] Integrate Devise to ActionCable Rails

#### Creating a new amazing app 😍

If you prefer for using PostgreSQL as a database

```bash
rails new amazing_app -d postgresql -m https://raw.githubusercontent.com/maful/eci-rails/master/template.rb
```

To run your app, use `foreman start`

#### Cleaning up 😢
```bash
rails db:drop
spring stop
cd ..
rm -rf amazing_app
```
