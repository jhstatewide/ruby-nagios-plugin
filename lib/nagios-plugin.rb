require 'optparse'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Nagios
  class Plugin
     VERSION = '0.0.1'
     OK_STATE = 0
     WARNING_STATE = 1
     CRITICAL_STATE = 2
     UNKNOWN_STATE = 3
     
     def initialize(args = {})
     	 @shortname = args[:shortname] || "Nagios::Plugin"
       @print = args[:print].nil? ? true : args[:print]                                                                                                                                                                                  
       @exit = args[:exit].nil? ?  true : args[:exit] 
     	 @perfdata = Hash.new
     	 
     	 # now, handle the arguments...
     	 @opts = OptionParser.new
     	 @opts.on("-w", "--warning WARNING", "WARNING THRESHOLD") do |w|
     	 	 @warning = w
	 end
	 @opts.on("-c", "--critical CRITICAL", "CRITICAL THRESHOLD") do |c|
     	 	 @critical = c
	 end
     end
     
     def warning
     	     @warning     
     end
     
     def critical
     	     @critical
     end
     
     def parse_argv()
     	     @opts.parse(ARGV)
     end
     
     def exit=(enabled)
     	     @exit = enabled
     end
     
     def print=(enabled)
     	     @print = enabled
     end
     
     # actually does the check
     def run
     	     raise "You must implement the run method!"
     end
     
     def state 
     	   @state
     end
     
     def output 
     	     @output
     end
     
     def add_perfdata(args)
     	   field = args[:field] or raise "must supply field!"
     	   data = args[:data] or raise "must supply data!"
     	   @perfdata[field] = {:data => data}
     	   @perfdata[field][:uom] = args[:uom] if args[:uom]
     	   @perfdata[field][:warning] = args[:warning] if args[:warning]
     	   @perfdata[field][:critical] = args[:critical] if args[:critical]
     end
     
     private
     
     def critical(message)
     	     @state = :CRITICAL
     	     do_exit(CRITICAL_STATE, message)
     end
     
     def ok(message)
     	     @state = :OK
     	     do_exit(OK_STATE, message)
     end
     
     def warning(message)
     	     @state = :WARNING
     	     do_exit(WARNING_STATE, message)
     end
     
     def unknown(message)
     	     @state = :UNKNOWN
     	     do_exit(UNKNOWN_STATE, message)
     end
     
     def do_exit(status, message)
     	     @output = @shortname + " "
     	     case status
     	     when OK_STATE
     	     	     @output += "OK - "
     	     when WARNING_STATE
     	     	     @output += "WARNING - "
     	     when CRITICAL_STATE
     	     	     @output += "CRITICAL - "
     	     when UNKNOWN_STATE
     	     	     @output += "UNKNOWN - "
     	     end
     	     @output += message
     	     # see if we have keys...
     	     if @perfdata.keys.length > 0
     	     	     @output += " | "
     	     	     outputs = []
     	     	     @perfdata.each_pair do |key, value|
     	     	     	     outputs << "#{key}=#{value[:data]}#{value[:uom]};#{value[:warning]};#{value[:critical]}"  
     	     	     end
     	     	     @output += outputs.join(", ")
     	     end
     	     @output.strip!
     	     puts @output if @print
     	     exit(status) if @exit
     	     return @output
     end
     
  end 
end
