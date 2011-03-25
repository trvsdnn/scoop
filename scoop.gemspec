# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scoop/version"

Gem::Specification.new do |s|
  s.name        = "scoop"
  s.version     = Scoop::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["blahed"]
  s.email       = ["tdunn13@gmail.com"]
  s.description = "Talk to S3 and scoop up some data"

  s.rubyforge_project = "scoop"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
