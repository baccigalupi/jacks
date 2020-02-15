# YAY! A new jacks app

Welcome to the land of Jacks. You are going to want to rewrite this soon so that
your peeps know how to setup and run your particular application.

## Setup

System dependencies:

* Postgres - Feel free to switch this later, but we recommend for fast startup
Sticking with Postgres for now!

### Configure the database name, maybe more

Go to `app/config/sequel.rb` and check out the details there. At a minimum,
you are going to want to change the database name. If you have setup postgres
with a password, or username that is not your system user, you will need to
change a bit more.

### Run the setup step to get the rest!

Now that you have installed the app run `bin/setup`.

It will install your Ruby gem dependencies, your node modules.

## Running the app

Jacks is a coordinated front and back end server. We use npm scripts to
coordinate.

    npm start

You should see output for the Rack/Puma server and also for the webpack asset
compilation.

Next go to `http://localhost:3000` and enjoy the show.

## Database management

Having a database is fun, but not as fun as actually using it. We are using the
[Sequel](https://sequel.jeremyevans.net/) for a light weight database 
abstraction. Migrations tasks are in rake similar to ActiveRecord.

Run `rake -T jacks:db` to see what is available.

Unlike the Rails world, running migrations will happen locally for both
development and test in one go, so you are never wondering why your tests are
unhappy while your development server is fine.

## Tests

Test have already been setup for you in `rspec` and `jest`. Currently they each
run independently:

    bundle exec rspec
    npm test

For CI, I would recommend rolling it a test with `standardrb` a ruby style guide
and `prettier`. Both are installed, opinionated but true.