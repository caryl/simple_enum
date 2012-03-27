# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_enums/version"

Gem::Specification.new do |s|
  s.name        = "simple_enums"
  s.version     = SimpleEnum::VERSION
  s.authors     = ["CarylWang"]
  s.email       = ["xianwei.wang@gmail.com"]
  s.homepage    = "http://github.com/caryl/simple_enum"
  s.summary     = %q{a plugin for using enum attribute.}
  s.description = %q{Simple Enum is a simple and useful plugin for using enum attribute.}

  #s.rubyforge_project = "simple_enum"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
