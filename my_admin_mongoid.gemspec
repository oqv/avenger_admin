# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "my_admin_mongoid/version"

Gem::Specification.new do |s|
  s.name        = "my_admin_mongoid"
  s.version     = MyAdminMongoId::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marcos Vinicius von Gal dos Santos"]
  s.email       = ["marcosvgs@gmail.com"]
  s.homepage    = ""
  s.summary     = "MyAdminMongoId"
  s.description = "MyAdminMongoId"

  s.rubyforge_project = "my_admin_mongoid"
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "rails",                   "~> 4.2.1"
  s.add_dependency "breadcrumbs"  ,           "0.1.6"
  s.add_dependency "dynamic_form" ,           "1.1.4"
  s.add_dependency "paperclip" ,              "3.5.1"
  s.add_dependency "mongoid-paperclip",       "0.0.10"
  s.add_dependency "will_paginate_mongoid",   "~> 2.0.1"
  s.add_dependency "to_xls",                  "1.5.3"
  s.add_dependency "spreadsheet",             "0.9.7"
  s.add_dependency "htmlentities",            "4.3.4"
  s.add_dependency "ckeditor",                "~> 4.1.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
