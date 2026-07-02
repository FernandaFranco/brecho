# Brechó Online

A full-featured second-hand marketplace built with Ruby on Rails 8, showcasing modern Rails conventions and the complete Solid Stack (Solid Queue, Solid Cache, Solid Cable) — no Redis required.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture Highlights](#architecture-highlights)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Project Structure](#project-structure)
- [Design Decisions](#design-decisions)

---

## Overview

Brechó Online is a mini marketplace where users can create listings for second-hand items, upload photos, search and filter by category/condition/price, and receive real-time view count updates when other users browse their listings.

The project was built as a Rails 8 learning exercise to explore the framework's latest conventions and the Solid Stack, which replaces external dependencies like Redis and Sidekiq with database-backed alternatives.

---

## Features

- **Native authentication** using Rails 8's built-in authentication generator (no Devise)
- **Multi-session management** — each login creates a tracked session with IP address and user agent
- **Listings CRUD** with ownership-scoped authorization
- **Multi-photo upload** with Active Storage and libvips image variants
- **Search and filters** by keyword, category, condition, and maximum price
- **Background jobs** with Solid Queue — listing expiration and email notifications
- **Transactional emails** with Action Mailer
- **Real-time view counter** using ActionCable and Solid Cable
- **Fragment caching** with Solid Cache and Russian Doll Caching
- **Rate limiting** on authentication endpoints (native Rails 8, no extra gems)
- **CI pipeline** with GitHub Actions running RSpec, Brakeman, bundler-audit, and RuboCop

---

## Tech Stack

| Layer            | Technology                           |
| ---------------- | ------------------------------------ |
| Language         | Ruby 3.4.3                           |
| Framework        | Rails 8.1.3                          |
| Database         | SQLite 3                             |
| Background Jobs  | Solid Queue                          |
| Caching          | Solid Cache                          |
| WebSockets       | ActionCable + Solid Cable            |
| Asset Pipeline   | Propshaft + Import Maps              |
| CSS              | Tailwind CSS 4                       |
| JavaScript       | Hotwire (Turbo + Stimulus)           |
| Image Processing | Active Storage + libvips             |
| Testing          | RSpec, Factory Bot, Shoulda Matchers |
| Security         | Brakeman, bundler-audit              |
| Linting          | RuboCop (omakase)                    |
| Deployment       | Kamal 2 + Thruster (configured)      |

---

## Architecture Highlights

### The Solid Stack

Rails 8 introduces three database-backed adapters that eliminate the need for Redis in most applications:

- **Solid Queue** handles background job processing using SQLite, replacing Sidekiq
- **Solid Cache** provides fragment and query caching using SQLite, replacing Memcached or Redis cache stores
- **Solid Cable** powers ActionCable's pub/sub mechanism using SQLite, replacing Redis as a WebSocket broker

Each adapter uses a dedicated SQLite database (`queue.sqlite3`, `cache.sqlite3`, `cable.sqlite3`), keeping concerns separated at the database level.

### Authentication

Authentication is implemented using Rails 8's native generator (`rails generate authentication`), which scaffolds the full authentication stack directly into the application — no black-box gems. This includes:

- `User` and `Session` models with `has_secure_password`
- `Current` (via `ActiveSupport::CurrentAttributes`) for thread-safe access to the current user across the request lifecycle
- Per-device session tracking with IP address and user agent logging
- Password reset flow via Action Mailer

### Authorization

Controller-level authorization is enforced through scoped queries:

```ruby
# Read: anyone can view active listings
def set_listing
  @listing = Listing.find(params.expect(:id))
end

# Write: only the owner can edit or destroy
def set_user_listing
  @listing = Current.user.listings.find(params.expect(:id))
end
```

### Fragment Caching (Russian Doll Caching)

Each listing partial is cached with a key derived from the record's `updated_at` timestamp. When a listing changes, its cache key changes automatically, invalidating stale fragments without manual cache busting:

```erb
<% cache listing do %>
  <%= render listing %>
<% end %>
```

### Real-time Updates

View counts are broadcast via ActionCable when a listing's `show` page is visited. The `ListingChannel` streams updates scoped to individual listings (`listing_#{id}`), and a Stimulus controller updates the DOM without a page reload.

---

## Getting Started

### Prerequisites

- Ruby 3.4.3 (via rbenv or asdf)
- Bundler
- libvips (for image variants)

```bash
brew install libvips   # macOS
sudo apt-get install libvips-tools   # Ubuntu/Debian
```

### Installation

```bash
git clone https://github.com/FernandaFranco/brecho.git
cd brecho
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

Open `http://localhost:3000` in your browser.

### Seeded Data

The seed file creates the following categories: Roupas, Eletronicos, Livros, Moveis, Esportes, Brinquedos, Outros.

Create a user account via `http://localhost:3000/session/new` to start creating listings.

---

## Running Tests

```bash
bundle exec rspec                          # full suite
bundle exec rspec spec/models             # model specs only
bundle exec rspec spec/requests           # request specs only
bundle exec rspec spec/jobs               # job specs only
```

Security and linting:

```bash
bin/brakeman --no-pager                   # static security analysis
bin/bundler-audit                         # known CVE check
bin/rubocop                               # style linting
```

### Test Coverage

| Layer    | Tool                     | What's covered                                                  |
| -------- | ------------------------ | --------------------------------------------------------------- |
| Models   | RSpec + Shoulda Matchers | Validations, associations, scopes, enums, custom validations    |
| Requests | RSpec                    | Full HTTP request/response cycle, authentication, authorization |
| Jobs     | RSpec                    | Job execution, mailer delegation                                |
| Mailers  | RSpec                    | Email recipients, subjects, body content                        |

---

## Project Structure

```
app/
  channels/
    listing_channel.rb          # ActionCable channel for real-time view counts
  controllers/
    concerns/
      authentication.rb         # Session management concern included in ApplicationController
    listings_controller.rb      # RESTful CRUD with ownership-scoped authorization
    sessions_controller.rb      # Login/logout with rate limiting
  jobs/
    listing_expiration_job.rb   # Marks listings older than 30 days as inactive
    listing_notification_job.rb # Sends confirmation email on listing creation
  mailers/
    listing_mailer.rb           # Transactional email for new listings
  models/
    current.rb                  # CurrentAttributes for thread-safe request state
    listing.rb                  # Enums, scopes, validations, Active Storage attachments
    session.rb                  # Per-device session tracking
    user.rb                     # has_secure_password, email normalization
config/
  queue.yml                     # Solid Queue worker and dispatcher configuration
  cache.yml                     # Solid Cache configuration
  cable.yml                     # Solid Cable configuration
  recurring.yml                 # Scheduled jobs (listing expiration runs daily at 6am)
db/
  queue_schema.rb               # Solid Queue database schema
  cache_schema.rb               # Solid Cache database schema
  cable_schema.rb               # Solid Cable database schema
spec/
  factories/                    # Factory Bot factories
  jobs/                         # Job specs
  mailers/                      # Mailer specs
  models/                       # Model specs
  requests/                     # Request specs
  support/
    authentication_helper.rb    # sign_in helper for request specs
```

---

## Design Decisions

**SQLite in production**: Rails 8 makes SQLite a viable production database for most workloads. The Solid Stack is specifically designed around it, and Litestream or similar tools handle replication and backups. This stack is ideal for applications that don't require horizontal database scaling.

**No Devise**: Rails 8's authentication generator produces readable, ownable code directly in the application. For a marketplace with straightforward auth requirements, this is preferable to a black-box engine.

**price_cents as integer**: Monetary values are stored as integers (cents) to avoid floating-point precision errors. Display formatting (`price_cents / 100.0`) is handled at the view layer.

**`dependent: :restrict_with_error` on Category**: Categories cannot be deleted while they have associated listings, preventing accidental data loss. This contrasts with `User`, which uses `dependent: :destroy` since listings without an owner have no value.

**Ownership-scoped writes**: Edit, update, and destroy actions query listings through `Current.user.listings`, making it impossible to accidentally operate on another user's data regardless of what ID is passed in the URL.

---

## Author

Fernanda Franco
[linkedin.com/in/ferfrancodias](https://linkedin.com/in/ferfrancodias) | [github.com/FernandaFranco](https://github.com/FernandaFranco)
