# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluxbox_apps_menu/version'

Gem::Specification.new do |spec|
  spec.name          = "fluxbox_apps_menu"
  spec.version       = FluxboxAppsMenu::VERSION
  spec.authors       = ["Fabio Mucciante"]
  spec.email         = ["fabio.mucciante@gmail.com"]
  spec.summary       = %q{Build the Fluxbox apps menu.}
  spec.description   = %q{The script read the .desktop files installed and build the application's menu under the Fluxbox home folder.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  
  spec.add_development_dependency "inifile"
  spec.add_development_dependency "thor"
end
