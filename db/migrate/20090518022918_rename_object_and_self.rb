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


class RenameObjectAndSelf < ActiveRecord::Migration
  def self.up
    change_table :connections do |t|
      t.rename :object_id, :obj_id
      t.rename :self_id, :connection_desc_id
    end
  end

  def self.down
    change_table :connections do |t|
      t.rename :obj_id, :object_id
      t.rename :connection_desc_id, :self_id
    end
  end
end
