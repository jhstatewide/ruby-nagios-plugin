require "rake"

Gem::Specification.new do |s|
  s.name = 'nagios-plugin'
  s.version = '0.0.1'
  s.summary = "Provides a base class for writing Nagios Plugins in Ruby"
  s.files = FileList["lib/nagios-plugin.rb", "test/**/*"]
  s.homepage = "https://github.com/analog-analytics/ruby-nagios-plugin"
  s.authors  = ["Joshua Harding", "Daniel Zajic"]
  s.email  = ["danielzajic@gmail.com"]
end