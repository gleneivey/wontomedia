# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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


class Node < ActiveRecord::Base
  validates_presence_of   :name, :message => "Node's name cannot be blank."
  validates_format_of     :name, :with => /^[a-zA-Z][a-zA-Z0-9._:-]*$/m,
    :message => "Node's name must start with a letter, and can "\
                "contain only letters, numbers, and/or the period, "\
                "colon, dash, and underscore."
  validates_uniqueness_of :name, :message =>
    "There is already a node with the same name."
end
