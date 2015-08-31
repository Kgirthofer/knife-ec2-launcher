#!/usr/bin/ruby
# This is a group of validity checkers for ec2-spinup files.
require 'set'

def validate_instance(s)
  s1 = Set.new ([
    # current as of July 2015
    # "general purpose"
    "t2.small",
    "t2.medium",
    "m1.small",
    "m1.medium",
    "m1.large",
    "m1.xlarge",
    "m3.medium",
    "m3.large",
    "m3.xlarge",
    "m3.2xlarge",
    "m4.large",
    "m4.xlarge",
    "m4.2xlarge",
    "m4.4xlarge",
    "m4.10xlarge",
    # "compute optimized"
    "c3.large",
    "c3.xlarge",
    "c3.2xlarge",
    "c3.4xlarge",
    "c3.8xlarge",
    "c4.large",
    "c4.xlarge",
    "c4.2large",
    "c4.4xlarge",
    "c4.8large",
    # "memory optimized"
    "m2.xlarge",
    "m2.2xlarge",
    "m2.4xlarge",
    "r3.large",
    "r3.xlarge",
    "r3.2xlarge",
    "r3.4xlarge",
    "r3.8xlarge",
    # "storage optimized"
    "hi1.4xlarge",
    "hs1.8xlarge",
    "i2.xlarge",
    "i2.2xlarge",
    "i2.4xlarge",
    "i2.8xlarge",
    "d2.xlarge",
    "d2.2xlarge",
    "d2.4xlarge",
    "d2.8xlarge",
    # "micro instances"
    "t1.micro",
    "t2.micro",
    # "gpu instances"
    "cg1.4xlarge",
    "g2.2xlarge",
    "g2.8xlarge"
    ])
  if s == ""
    "t2.micro"
  elsif s1.include? s
    s
  else
    puts "Invalid format/selection, please enter a valid instance type".red
    get_instance()
  end
end

def validate_env(s)
  case s
  when 'dev', 'prod'
    s.downcase
  else
    puts "Please enter a valid Environment".red
    get_env()
  end
end

def validate_sn(env,az)
  case env
  when "dev"
    if az == "a"
      "5a79a82d"
    elsif az == "b"
      "5a79a82d"
    elsif az == "c"
      "5a79a82d"
    else
      abort("Selected AZ is not configured, Program will now fail!")
    end
  end
end

def validate_region(s)
  valid_region = Set.new ([
    #all auto scaling regions
    "us-east-1", #virginia
    "us-west-1", #california
    "us-west-2", #oregon
    "eu-west-1", #ireland
    "eu-central-1", #frankfurt
    "ap-southeast-1", #singapore
    "ap-southeast-2", #sydney
    "ap-northeast-1", #tokyo
    "sa-east-1" #sao paulo
  ])
  if s == ""
    "us-east-1"
  elsif valid_region.include? s
    s
  else
    puts "Invalid format/selection, please enter a valid region".red
    get_region()
  end
end

def validate_az(region, s)
  case region.to_s.downcase
  when "us-east-1"
    valid_az = Set.new ["a","b","c","d","e"]
    if s == ""
      "c"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "us-west-1"
    valid_az = Set.new ["a","b","c"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "us-west-2"
    valid_az = Set.new ["a","b","c"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "eu-west-1"
    valid_az = Set.new ["a","b","c"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "eu-central-1"
    valid_az = Set.new ["a","b"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "ap-southeast-1"
    valid_az = Set.new ["a","b"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "ap-southeast-2"
    valid_az = Set.new ["a","b"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "ap-northeast-1"
    valid_az = Set.new ["a","b","c"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  when "sa-east-1"
    valid_az = Set.new ["a","b"]
    if s == ""
      "a"
    elsif valid_az.include? s
      s
    else
      puts "Invalid format/selection, please enter a valid az".red
      get_az()
    end
  end
end
def validate_ebs(vol)
  return vol if vol.between?(1,1024)
  puts "Invalid EBS size, must be 1-1024".red
  get_vol()
end
def validate_sg(sg)
  return sg
end
def validate_additional_sg(sg)
  return sg if sg.length == 8
  puts "Invalid Security Group, must be 8 Hex digits".red
  get_secondary_sg()
end
def validate_subnet(subnet)
  return subnet if subnet.length == 8
  puts "Invalid Subnet, must be 8 hex digits".red
  get_sn()
end

def validate_ami(ami)
  return ami if ami.length == 8
  puts "Invalid AMI, must be 8 hex digits".red
  get_ami()
end

