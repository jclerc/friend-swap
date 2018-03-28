<h1 align="center">
  <img alt="friend-swap" width="652" src="https://jclerc.github.io/assets/repos/banner/friend-swap.jpg">
  <br>
</h1>

<p align="center">
  <img alt="made for: school" src="https://jclerc.github.io/assets/static/badges/made-for/school.svg">
  <img alt="language: ruby" src="https://jclerc.github.io/assets/static/badges/language/ruby.svg">
  <img alt="made in: 2017" src="https://jclerc.github.io/assets/static/badges/made-in/2017.svg">
  <br>
  <sub>Marketplace for friends: trade yours against another!</sub>
</p>
<br>

## Live demo

See the project here: [friendswap.herokuapp.com](https://friendswap.herokuapp.com/)

## Features

- [x] Discover the best friends or popular tags
- [x] Search friends by tags/city
- [x] Add, edit and manage your friends
- [x] Start an exchange, end it and rate the friend

## Stack used

- Devise `4.3.0`
- Paperclip `5.1.0`
- Rails `5.1.4`
- Ruby `2.4.2`

## Getting started

#### Requirements

- `bundler`
- `rails`
- Ruby 2.4+

#### Installation

```sh
git clone https://github.com/jclerc/friend-swap.git
cd friend-swap
# install dependencies
bundle install
# create database and fill it (can take some time)
rake db:setup db:seed
# start server
rails server
```

## Notes

- Credentials on demo site are:
  - admin email: **test@test**, password: **test@test**
  - any user password: **test@test** (and see their email at the bottom of any friend page)
