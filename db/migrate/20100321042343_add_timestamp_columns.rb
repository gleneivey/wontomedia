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


class AddTimestampColumns < ActiveRecord::Migration
  def self.up
    add_column :items, :created_at, :datetime
    add_column :items, :updated_at, :datetime
    add_column :connections, :created_at, :datetime
    add_column :connections, :updated_at, :datetime
  end

  def self.down
    remove_column :items, :created_at
    remove_column :items, :updated_at
    remove_column :connections, :created_at
    remove_column :connections, :updated_at
  end
end
