require File.dirname(__FILE__) + '/test_helper.rb'


class TestPlugin < Nagios::Plugin
	def run
	    critical("waffles are getting really low...")
	end
end

class TestNagiosPlugin < Test::Unit::TestCase

  def setup
  	  @tp = TestPlugin.new(:shortname => "Waffles", :exit => false, :print => false)
  end
  
  def test_critical
  	  output = @tp.run
  	  assert_equal("Waffles CRITICAL - waffles are getting really low...", output)
  end
  
  def test_perf
  	  @tp.add_perfdata(:field => "waffles_per_second", :data => 10, :warning => 2, :critical => 5, :uom => "wps")
  	  @tp.run
  	  output = @tp.output
  	  assert_equal("Waffles CRITICAL - waffles are getting really low... | waffles_per_second=10wps;2;5", output)
  end
end
