Gem::Specification.new do |s|

  s.name            = 'logstash-codec-rfc822'
  s.version         = '0.0.1'
  s.licenses        = ['Apache-2.0']
  s.summary         = "Parses email messages into fields"
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["John Carr"]
  s.email           = 'john.carr@unrouted.co.uk'
  s.homepage        = "https://github.com/Jc2k/logstash-codec-rfc822"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir["lib/**/*","spec/**/*","*.gemspec","*.md","CONTRIBUTORS","Gemfile","LICENSE","NOTICE.TXT", "vendor/jar-dependencies/**/*.jar", "vendor/jar-dependencies/**/*.rb", "VERSION", "docs/**/*"]

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency "logstash-core", ">= 5.5.2"
  s.add_runtime_dependency 'mail', '~> 2.6'
  s.add_runtime_dependency 'stud', '~> 0.0.22'

  s.add_development_dependency 'logstash-devutils', '= 1.3.6'
end
