# knife-ec2-launcher

# prerequisits
  Chef-client installed
  Chef server configured (chef.io)
  gem install colorized
  Ruby 2.0 or above

# Preliminary configurations
  Adjust lib/check-valid.rb and adjust for your environments/subnets. (Starting on line 83)
  Adjust lib/matchingEc2Input.rb adjusting defaults as required (i.e. security group line 58)
  Do the same for lib/multiRoleInput.rb
  Make sure both the chef-secret file and your AWS keypair are in ~/.ssh/ with proper perms
  Make sure you have your chef-knife configured in .chef/knife.rb with your AWS creds
        knife[:aws_access_key_id]     = 'AWS_ACCESS_KEY_ID'
        knife[:aws_secret_access_key] = 'AWS_SECRET_ACCESS_KEY'
  
# Usage
        to test
        %> ./launcher.rb -t
        to run
        %> ./launcher.rb
# Run types
  Run 1. if you would like to launch a cluster of identical servers, running in threads
  This can be resource intensive, so be aware that it will use a lot of ram depending on 
  how many threads you're running.
  Run 2. if you are looking to pre-load various Chef runlist roles. 
    To run this way, you must first pre-populate the runlist-roles in lib/roles.rb, these
    should be comma separated strings. ["role1","role2"] so on and so forth.
  
