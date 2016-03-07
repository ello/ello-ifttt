<img src="http://d324imu86q1bqn.cloudfront.net/uploads/user/avatar/641/large_Ello.1000x1000.png" width="200px" height="200px" />

# Ello IFTTT Integration

[![Build Status](https://travis-ci.org/ello/ello-ifttt.svg?branch=master)](https://travis-ci.org/ello/ello-ifttt)
[![Code Climate](https://codeclimate.com/github/ello/ello-ifttt/badges/gpa.svg)](https://codeclimate.com/github/ello/ello-ifttt)
[![security](https://hakiri.io/github/ello/ello-ifttt/master.svg)](https://hakiri.io/github/ello/ello-ifttt/master)

This app manages all of the ins and outs of Ello's integration with
[IFTTT](https://ifttt.com/). It uses a combination of JWT OAuth tokens, Ello API
calls, and a Kinesis stream consumer to both send triggers and service actions.

### Setup

This is a vanilla Rails 5 (API) application, so getting it started is fairly
standard:

* Install RVM/Rbenv/Ruby 2.3
* Install PostgreSQL (9.4 or newer) if you don't have it already
* Clone this repo
* Run `bundle install` and `bundle exec rake db:setup`
* Fire up the API server with `bundle exec rails server`
* Run the test suite with `bundle exec rake`

##### Deployment, Operations, and Gotchas
To be written

## License
Streams is released under the [MIT License](blob/master/LICENSE.txt)

## Code of Conduct
Ello was created by idealists who believe that the essential nature of all human beings is to be kind, considerate, helpful, intelligent, responsible, and respectful of others. To that end, we will be enforcing [the Ello rules](https://ello.co/wtf/policies/rules/) within all of our open source projects. If you don’t follow the rules, you risk being ignored, banned, or reported for abuse.
