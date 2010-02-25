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


# see wontomedia/doc/script/rake-customize.markdown for usage

desc "This creates symbolic links to customization files in other directories"
task :customize, :path_list do |t, args|

  # first, clear out all symbolic links from any previous
  # configurations--we don't want to leave any old ones lying around
  # pointing into customization directories we aren't currently using.
  FileList[ "*", "**/*"].
    exclude do |maybe_not_link|
      !File.symlink?(maybe_not_link)
    end.
    each do |link_to_delete|
      File.delete link_to_delete
    end

  # now, build new links
  paths = args[:path_list].split(':')
  paths.each do |p|
    path = File.expand_path(p)
    Dir[ File.join( path, "**", "*" ) ].each do |from_p|
      if File.file?( from_p )
        from_absolute = File.expand_path(from_p)
        from_path = File.dirname( from_absolute )
        file_name = File.basename( from_absolute )

        sublength = (from_path.length - path.length) - 1
        relative = from_path[ -sublength, sublength ]
        to_absolute = File.expand_path( relative )
        to_name = File.join( to_absolute, file_name )

        if File.exists?( to_name )
          unless File.symlink?( to_name )
            puts "WARNING: replacing regular file '#{to_name}' "\
                   " with symbolic link."
          end
          File.delete( to_name )
        end

        path_so_far = File.expand_path( '.' )
        relative.split( File::SEPARATOR ).each do |dir_name|
          path_so_far = File.join( path_so_far, dir_name )
          unless File.exists?( path_so_far )
            Dir.mkdir( path_so_far )
          end
        end
        File.symlink( from_absolute, to_name )
      end
    end
  end
end

