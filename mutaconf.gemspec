# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mutaconf"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["AlphaHydrae"]
  s.date = "2013-04-14"
  s.description = "Create simple DSLs and read configuration from hashes or objects."
  s.email = "hydrae.alpha@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".ruby-gemset",
    ".ruby-version",
    ".screenrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/mutaconf.rb",
    "lib/mutaconf/dsl.rb",
    "lib/mutaconf/errors.rb",
    "lib/mutaconf/target.rb",
    "mutaconf.gemspec",
    "spec/block_spec.rb",
    "spec/env_spec.rb",
    "spec/extract_spec.rb",
    "spec/fixtures/eval.rb",
    "spec/helper.rb",
    "spec/source_spec.rb",
    "spec/subclass_spec.rb",
    "spec/target_spec.rb",
    "spec/version_spec.rb"
  ]
  s.homepage = "http://github.com/AlphaHydrae/mutaconf"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Configuration utilities."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
      s.add_development_dependency(%q<gem-release>, [">= 0"])
      s.add_development_dependency(%q<rake-version>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
      s.add_dependency(%q<gem-release>, [">= 0"])
      s.add_dependency(%q<rake-version>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
    s.add_dependency(%q<gem-release>, [">= 0"])
    s.add_dependency(%q<rake-version>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

