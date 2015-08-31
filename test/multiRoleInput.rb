#!/usr/bin/ruby
# Spins up one instance for every role listed in ecmms-roles.rb
require 'set'
require 'colorize'
require_relative 'check-valid'
require_relative 'knifeThreads'
require 'thread'
#adjust to the roles file you have created
require_relative 'roles.rb'

begin
  servers = Roles.runList_roles.length
  threads = Roles.runList_roles.length

  puts "************************************************".red
  puts "THIS IS A TEST RUN - NO SERVERS WILL BE CREATED".red
  puts "OUTPUT WILL BE PRINTED - NOT RAN".red
  puts "Launching EC2 instances based on number of roles".red
  print "There will be ".red
  print "#{servers}".green
  puts " servers created!".red
  puts "Please exit now if this is incorrect!".red
  puts "************************************************".red
  def get_user_name()
    print "Default username? (default ubuntu): ".yellow
    uname = gets.to_s.downcase.chomp
    (uname.length < 1)? "ubuntu" : uname
  end
  def get_region()
    print "Region (default us-east-1): ".yellow
    region = gets.to_s.downcase.chomp
    (region.length <1)? "us-east-1" : validate_region(region)
  end
  def get_name()
    print "Server Name Prefix, Numbering is automatic: ".yellow
    gets.to_s.downcase.chomp
  end
  def get_env()
    print "Environment (default dev): ".yellow
    env = gets.to_s.downcase.chomp
    (env.length < 1)? "dev" : validate_env(env)
  end
  def get_az(region)
    print "Availability-zone (default a): ".yellow
    az = gets.to_s.downcase.chomp
    (az.length < 1)? "a" : validate_az(region, az)
  end
  def get_sn(env,az)
    validate_sn(env,az)
  end
  def get_instance()
    print "Server Type (default t2.micro): ".yellow
    validate_instance(gets.to_s.downcase.chomp)
  end
  def get_sg()
    puts "Security Group (default sg-72fed817)".green
    print "Enter multiple security groups separated by \',\': ".yellow
    sg = gets.to_s.downcase.delete(' ').chomp
    (sg.length < 1)? "sg-72fed817" : validate_sg(sg)
  end
  def get_vol()
    print "EBS Volume Size GB (default 20): ".yellow
    ebs = gets.to_s.chomp
    (ebs.length < 1)? 20 : validate_ebs(ebs.to_i)
  end
  def get_ami()
    print "AMI (default us-east-1 ubuntu 14.04): ami-".yellow
    ami = gets.to_s.downcase.chomp
    (ami.length < 1)? "9eaa1cf6" : validate_ami(ami)
  end
  def get_owner()
    print "Owner's Name: ".yellow
    owner = gets.to_s.chomp
    (owner.length < 1)? "None" : owner.split.map(&:capitalize).join(' ')
  end
  def get_pem()
    print "Pem file name: ".yellow
    pem = gets.to_s.chomp
    if pem == ""
      puts "Must enter PEM file!".red
      get_pem()
    else
      return pem.chomp('.pem')
    end
  end
  def get_sf()
    print "Chef Secret File Name: ".yellow
    sf = gets.to_s.chomp
    if sf == ""
      puts "Must enter PEM file!".red
      get_sf()
    else
      return sf.chomp('.pem')
    end
  end
  def get_iam()
    print "IAM Role: ".yellow
    gets.to_s.chomp
  end

  uname = get_user_name()
  region = get_region()
  name = get_name()
  env = get_env()
  az = get_az(region)
  subnet = get_sn(env,az)
  puts "Using Subnet subnet-#{subnet}".green
  instanceType = get_instance()
  sg = get_sg()
  ebs = get_vol()
  ami = get_ami()
  pem = get_pem()
  secret_file = get_sf()
  owner = get_owner()
  iam_role = get_iam()
  
  thread_by_role(uname,region,name,env,az,subnet,instanceType,sg,ebs,ami,pem,secret_file,owner,iam_role,servers,threads)

rescue Interrupt
  puts "\nExiting...".red
end

