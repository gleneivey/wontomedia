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

class Files
  TEMPLATE_FILES_PATH = File.join("policy", "copyright-notices", "*")
  
  def self.all_files_in_this_tree
    Dir.glob( File.join("**", "*"), File::FNM_DOTMATCH ).
      reject { |path| File.directory?(path) }
  end

  def self.template_files
    Dir.glob(TEMPLATE_FILES_PATH)
  end

  def self.normalize_path(path)
    components = path.split(File::SEPARATOR)
    components.join("/")
  end
  def self.denormalize_path(path)
    components = path.split('/')
    File.join(components)
  end
end


