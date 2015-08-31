#!/usr/bin/ruby
require 'set'
require 'colorize'
require 'optparse'

begin
  options = {}

  parser = OptionParser.new do|opts|
    opts.banner = "Usage: launcher.rb [options]"
    opts.on('-t', '--test', 'Test') do |test|
      options[:test] = true
    end
    opts.on('-h', '--help', 'Displays Help') do
      puts opts
      exit
    end
  end.parse!

  puts "This is a test run!".red if options[:test]

  def validate_ans(ans)
    valid_ans = Set.new ["1","2"]
    if ans == ""
      puts "Empty - invalid".red
      get_run()
    elsif valid_ans.include? ans
      ans
    else
      puts "Invalid selection, enter a valid choice".red
      get_run()
    end
  end

  def get_run()
    puts "Please select how you would like to launch ec2 instances by number".green
    sleep(1)
    puts "1. Launch identical instance cluster".yellow
    puts "2. Launch multiple instances with varying chef roles".yellow
    print ":> ".green
    ans = gets.to_s.chomp
    sleep(1)
    validate_ans(ans)
  end

  def run_app(app,test)
    case app
    when "1"
      test ? (load "test/matchingEc2Input.rb") : (load "lib/matchingEc2Input.rb")
    when "2"
      test ? (load "test/multiRoleInput.rb") : (load "lib/multiRoleInput.rb")
    end
  end

  run_app(get_run(),options[:test])

rescue Interrupt
  puts "\nExiting...".red
end

