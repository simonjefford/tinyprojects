require "rubygems"
require "spec"
require File.join(File.dirname(__FILE__), "..", "lib", "gil")

def get_fixture_path(fixturename)
  File.dirname(__FILE__) + "/fixtures/#{fixturename}"
end
