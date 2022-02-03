# -*- encoding: utf-8 -*-
# stub: easy-box-packer 0.0.8 ruby .

Gem::Specification.new do |s|
  s.name = "easy-box-packer".freeze
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = [".".freeze]
  s.authors = ["Aloha Chen".freeze]
  s.date = "2018-04-26"
  s.email = "y.alohac@gmail.com".freeze
  s.homepage = "https://github.com/alChaCC/easy-box-packer".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.32".freeze
  s.summary = "3D bin-packing with weight limit using first-fit decreasing algorithm and empty maximal spaces".freeze

  s.installed_by_version = "3.2.32" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1", ">= 3.1.0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1", ">= 3.1.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
  end
end