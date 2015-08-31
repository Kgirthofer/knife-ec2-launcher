#!/usr/bin/ruby
# This is a list of roles on the chef server, when called upon by ec2-spinup-multiRoles.rb will create one server for every role listed
# Fill in roles like so
# @runList_roles = ["role1", "role2", "role3"]

module Roles
  @runList_roles = []

  def self.runList_roles
    @runList_roles
  end
end

