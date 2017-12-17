# LeBonCopain

Trade a friend against another!

## Demo

Try it here: **[https://hetic-g2-4.herokuapp.com/](https://hetic-g2-4.herokuapp.com/)**

Credentials:
- admin email: **test@test**, password: **test@test**
- any user password: **test@test** (see their email at the bottom of any friend page)

## Features

- Discover the best friends or popular tags
- Search friends by tags/city
- Add, edit and manage your friends
- Start an exchange, end it and rate the friend

## Stack used

- [Ruby](https://www.ruby-lang.org/) 2.4.2
- [Rails](http://rubyonrails.org/) 5.1.4
- [Devise](https://github.com/plataformatec/devise) 4.3.0
- Database:
  - development: [SQLite](https://www.sqlite.org/)
  - production: [PostgreSQL](https://www.postgresql.org/)
- Avatars: [paperclip](https://github.com/thoughtbot/paperclip) with [AWS S3](https://aws.amazon.com/s3/)

## Getting started

```bash
# clone project - approx. 25mb
git clone https://github.com/JClerc/RuBnB.git
# go into project directory
cd RuBnB
# install dependencies
bundle install
# create database and fill it (can take some time)
rake db:setup db:seed
# start server
rails server
```

## Need help?

Create an [issue](https://github.com/JClerc/RuBnB/issues)!
