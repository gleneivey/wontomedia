#!/usr/bin/ruby

# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
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


require 'fileutils'

HOSTING_HOME_DIR = '/home/glenivey'
RAILS_PATH = "#{HOSTING_HOME_DIR}/etc/rails_apps"
GEMPATH = "#{HOSTING_HOME_DIR}/ruby/gems"
GEMPATH_SED_COMMAND = '/^RAILS_GEM_VERSION/aGem.use_paths \\"/home/glenivey/ruby/gems\\", [ \\"/home/glenivey/ruby/gems\\", \\"/usr/lib/ruby/gems/1.8\\" ]'

SERVER_DIR = {
  'wontology'     => "#{RAILS_PATH}/WontoMedia",
  'adasdaughters' => "#{RAILS_PATH}/AdasDaughtersWM"
}
FILE_PREFIX = {
  'wontology'     => 'wm',
  'adasdaughters' => 'ad'
}
CUSTOMIZE_ARG = {
  'wontology'     => ":#{HOSTING_HOME_DIR}/SiteConfigs/wontology.org",
  'adasdaughters' => ":#{HOSTING_HOME_DIR}/SiteConfigs/adasdaughters.org"
}
APACHE_DOCUMENT_ROOT = {
  'wontology'     => "#{HOSTING_HOME_DIR}/www",
  'adasdaughters' => "#{HOSTING_HOME_DIR}/www/adasdaughters.org"
}

if ARGV.length != 1
  STDERR.puts "Usage: install-wontomedia.rb [target instalation symbol]"
  exit 1
end
unless SERVER_DIR[ARGV[0]]
  STDERR.puts "Supplied target installation symbol is unknown"
  exit 1
end

$target = ARGV[0]
$install_dir = "#{HOSTING_HOME_DIR}/Install/#{$target}"
$log_dir = "#{HOSTING_HOME_DIR}/Logs/#{$target}"
$server_dir = SERVER_DIR[$target]
$configs_prefix = "#{HOSTING_HOME_DIR}/SiteConfigs/#{FILE_PREFIX[$target]}"




def archive_logs_and_uninstall_old
  [ 'mongrel.log', 'production.log'].each do |file|
    `cat #{$server_dir}/log/#{file} >> #{$log_dir}/#{file}`
  end

  begin
    FileUtils.rm_rf "#{$install_dir}"
    FileUtils.rm $server_dir
  rescue
    ; # don't care if these weren't present
  end
end


def build_target_dir_and_install_new
    # build a per-install gem environment
  FileUtils.makedirs "#{$install_dir}"

  FileUtils.ln_s Dir.glob( "#{GEMPATH}/*" ), "#{$install_dir}"
  gems = "#{$install_dir}/gems"
  FileUtils.rm gems  # need to break this out

  FileUtils.makedirs gems
  FileUtils.ln_s Dir.glob( "#{GEMPATH}/gems/*" ), gems
  FileUtils.rm Dir.glob( "#{gems}/wontomedia*" )

  # do the install
  `gem install --install-dir #{$install_dir} -l wontomedia`

  # map the install into the directory A2's default config wants
  FileUtils.ln_s Dir.glob( "#{gems}/wontomedia*" )[0], "#{$server_dir}"
end


def configure_installation
  FileUtils.cd $server_dir
  FileUtils.makedirs [ "log", "tmp" ]

  # per-installation configuration files
  FileUtils.cp "#{$configs_prefix}.database.yml", "config/database.yml"
  FileUtils.cp "#{$configs_prefix}.wontomedia.rb",
    "config/initializers/wontomedia.rb"
  `sed --in-place=.backup -e "#{GEMPATH_SED_COMMAND}" config/environment.rb`

    # kludge: some browsers don't apply CSS relative URLs correctly
  FileUtils.cp( Dir.glob( "public/stylesheets/*.gif" ), "public" )

    # customize installation
  ENV['RAILS_ENV'] = 'production'
  `rake customize[default-custom#{CUSTOMIZE_ARG[$target]}]`
  `rake asset:packager:build_all`

    # pre-gzip packaged/combined assets
  [   [ 'stylesheets', 'css'],
      [ 'javascripts', 'js' ] ].each do |params|
    dir = params[0]
    extension = params[1]
    document_dir = "#{APACHE_DOCUMENT_ROOT[$target]}/#{dir}"

    FileUtils.makedirs document_dir
    FileUtils.cp(
      Dir.glob( "public/#{dir}/*_packaged.#{extension}" ), document_dir )
    `gzip -f #{document_dir}/*`
  end
end



archive_logs_and_uninstall_old
build_target_dir_and_install_new
configure_installation
