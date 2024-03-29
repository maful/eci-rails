# Eci Rails Template

Special thanks to [@excid3](https://github.com/excid3) (Creator of GoRails.com) for inspiring me to create this project.

> [Libur.run](https://github.com/maful/libur.run) - Empower Your HR with Next-Gen Open Source Self-Serve Platform

## Getting Started

👉 Eci requires Rails >= 6.0

#### Features
*   Authentication
*   Webpacker configuration by default
*   [Tailwind CSS](https://tailwindcss.com/) as a CSS framework
*   Included testing

#### Roadmap

- [ ] Add OmniAuth
- [ ] Use Tailwind CSS components by default
- [x] Use Sidekiq for background processing
- [x] Integrate Devise to ActionCable Rails
- [x] Setup RSpec, FactoryBotRails, Faker and much more
- [ ] Setup Docker out of the box

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
