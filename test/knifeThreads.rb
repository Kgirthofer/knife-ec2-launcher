#!/usr/bin/ruby
require 'set'
require 'thread'
require_relative 'roles.rb'

begin
  def Exception.ignoring_exceptions
    begin
      yield
    rescue Exception => e
      STDERR.puts e.message
    end
  end

  module Enumerable
    def in_parallel_n(n)
      todo = Queue.new
      ts = (1..n).map{
        Thread.new{
          while x = todo.deq
            Exception.ignoring_exceptions{ yield(x[0]) }
          end
        }
      }
      each{|x| todo << [x]}
      n.times{ todo << nil }
      ts.each{|t| t.join}
    end
  end

  def thread_by_role(uname,region,name,env,az,subnet,instanceType,sg,ebs,ami,pem,sf,owner,iam_role,servers,threads)
    data = {}
    (1..servers).in_parallel_n(threads){|i|
      time = i
      data[env] = [
       {
          :subnet        => subnet,
          :uname         => uname,
          :hn            => name,
          :az            => az,
          :region        => region,
          :inst_type     => instanceType,
          :ebs           => ebs,
          :sg            => sg,
          :ami           => ami,
          :pem           => pem,
          :sf            => sf,
          :owner         => owner,
          :iam_role      => iam_role,
          :json_bool     => json_bool
       }
      ]
      # prevent API call overload (3/second max)
      sleep time
      # make it stream
      $stdout.sync = true
      STDOUT.sync  = true
      data.each do |k,v|
        v.each do |instance|
          puts "chef exec knife ec2 server create \
            --ssh-user '#{instance[:uname]}' \
            --identity-file ~/.ssh/#{instance[:pem]}.pem \
            --secret-file ~/.ssh/#{instance[:sf]}.pem \
            --availability-zone '#{instance[:region]}#{instance[:az]}' \
            --flavor '#{instance[:inst_type]}' \
            --ebs-size '#{instance[:ebs]}' \
            --image 'ami-#{instance[:ami]}' \
            --ssh-key '#{instance[:pem]}' \
            --region '#{instance[:region]}' \
            --iam-profile '#{instance[:iam_role]}' \
            --security-group-ids '#{instance[:sg]}' \
            --subnet 'subnet-#{instance[:subnet]}' \
            --tags 'Name=#{instance[:hn]}#{i.to_s},Owner=#{instance[:owner]},Environment=#{k.to_s.upcase},OS=Linux,Autoscale=No' \
            --environment '#{k.to_s.downcase}' \
            --run-list 'role[#{Roles.runList_roles[i-1]}]'"
#          IO.popen cmd do |f|
#            until f.eof?
#              puts f.gets
#            end
#          end
        end
      end
    }
  end

  def thread_identical(uname,region,name,env,az,subnet,instanceType,sg,ebs,ami,pem,sf,owner,iam_role,servers,threads,run_list)
    data = {}
    (1..servers).in_parallel_n(threads){|i|
      time = i
      data[env] = [
       {
          :uname         => uname,
          :subnet        => subnet,
          :hn            => name,
          :az            => az,
          :region        => region,
          :inst_type     => instanceType,
          :ebs           => ebs,
          :sg            => sg,
          :rl            => run_list,
          :ami           => ami,
          :pem           => pem,
          :sf            => sf,
          :owner         => owner          
        }
      ]
      # sleep so not to over-call the AWS API (3/second)
      # sleep time will cause one api call per second
      sleep time
      # make it stream
      $stdout.sync = true
      STDOUT.sync  = true
      data.each do |k,v|
        v.each do |instance|
          puts "chef exec knife ec2 server create \
            --ssh-user '#{instance[:uname]}' \
            --identity-file ~/.ssh/#{instance[:pem]}.pem \
            --secret-file ~/.ssh/#{instance[:sf]}.pem \
            --availability-zone '#{instance[:region]}#{instance[:az]}' \
            --flavor '#{instance[:inst_type]}' \
            --ebs-size '#{instance[:ebs]}' \
            --image 'ami-#{instance[:ami]}' \
            --ssh-key '#{instance[:pem]}' \
            --region '#{instance[:region]}' \
            --iam-profile '#{instance[:iam_role]}' \
            --security-group-ids '#{instance[:sg]}' \
            --subnet 'subnet-#{instance[:subnet]}' \
            --tags 'Name=#{instance[:hn]}#{i.to_s},Owner=#{instance[:owner]},Environment=#{k.to_s.upcase},OS=Linux,Autoscale=No' \
            --environment '#{k.to_s.downcase}' \
            --run-list '#{instance[:rl]}'"
#          IO.popen cmd do |f|
#            until f.eof?
#              puts f.gets
#            end
#          end
        end
      end
    }
  end
rescue Interrupt
  puts "\nExiting..."
end

