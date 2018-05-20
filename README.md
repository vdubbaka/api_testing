# SplunkSdet

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/splunk_sdet`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'splunk_sdet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install splunk_sdet
##install and run
base assumption is that you have RVM installed and configured on your machine otherwise install rvm
1. clone the repo
2. cd into the repo
3. gem install bundler -v 1.12.5
4. bundle install
## Usage
right click on the tests to run they click on run
or on cmd line /rails/runner <path to script name>

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Bugs found in this project

1. For  "id": 49026,  "id": 20776,   "id": 155, neither title or original_title includes “batman”
2. All attributes are not well defined as some have poster_path, backdrop_path and some do not 
3. Count parameter is not functioning as defined 
4. title and original_title what do they represent?, Should they be same? what does name attribute “q” refer to title or original title
results are not sorted
5. Posting is not creating movie in in database but thowing success message

SPL-001: No two movies should have the same image :
3 movies have same images
for  "id": 186579, "id": 93560, poster paths are same and for “id": 138757, backdrop path is same as these.

SPL-002: All poster_path links must be valid. poster_path link of null is also acceptable
4 movies do not have poster_paths or backdrop_path


SPL-003: Sorting requirement. Rule #1 Movies with genre_ids == null should be first in response. Rule #2, if multiple movies have genre_ids == null, then sort by id (ascending). For movies that have non-null genre_ids, results should be sorted by id (ascending)
Not sorted as per business rule SPL 003 where Movies with genre_ids == null should be first in response.

SPL-004, SPL-005, SPL-006 meets the rules.
