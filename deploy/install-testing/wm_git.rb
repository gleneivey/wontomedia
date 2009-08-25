#!/usr/bin/ruby

# WontoMedia - a wontology web application
# Copyright (C) 2009 - Glen E. Ivey
#    www.wontology.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version
# 3 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program in the file COPYING and/or LICENSE.  If not,
# see <http://www.gnu.org/licenses/>.


#test_git_source = "git://10.201.2.100/~gei/wontomedia/"
### Note:  below is a GitHub "public" clone URL, which means you won't
### be able to push any changes you make back to GitHub.  Better would be
### to get permission to commit and use the "Your Clone URL", or to
### create your own fork on GitHub and clone from there.  See:
###
###    http://github.com/guides/fork-a-project-and-submit-your-modifications
###
### and GitHub's other guides (http://github.com/guides/)
test_git_source = "git://github.com/gleneivey/wontomedia.git"


          # clone WontoMedia from a repository
cmd = "git clone #{test_git_source}"
puts cmd
`#{cmd}`
exit $?.exitstatus if $?.exitstatus != 0


          # make sure we've got the databases in place
puts "mysql CREATE/GRANT"
IO.popen("mysql -u root -pmysql", "r+") { |mysql|
  mysql.write( "CREATE DATABASE wm_dev_db;\n" )
  mysql.write( "GRANT ALL PRIVILEGES ON wm_dev_db.* TO 'wm'\@'localhost' " +
                 "IDENTIFIED BY 'wm-pass';\n" )
  mysql.write( "quit\n\n" )
}


          # write a new "database.yml" file in our Git directory
puts "wontomedia/config/database.yml"
yml_file = File.readlines("wontomedia/config/database-mysql-development.yml")
yml_file.each do |file_line|
  file_line.sub! /wontomedia_test/, "wm_test_db"
  file_line.sub! /wontomedia_development/, "wm_dev_db"
  file_line.sub! /wontomedia-user/, "wm"
  file_line.sub! /replace-bad-passwd/, "wm-pass"
end

db_yml = File.new("wontomedia/config/database.yml", "w")
db_yml.write( yml_file.join );
db_yml.close()

