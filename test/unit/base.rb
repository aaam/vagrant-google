require "rubygems"
require "rspec/autorun"

# Require Vagrant itself so we can reference the proper
# classes to test.
require "vagrant"
require "vagrant-google"

# Add the test directory to the load path
$LOAD_PATH.unshift File.expand_path("../../", __FILE__)

# Do not buffer output
$stdout.sync = true
$stderr.sync = true

# Configure RSpec
RSpec.configure do |c|
  c.formatter = :progress
end
