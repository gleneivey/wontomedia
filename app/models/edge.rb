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


class Edge < ActiveRecord::Base
  belongs_to :subject,   :class_name => "Node"
  belongs_to :predicate, :class_name => "Node"
  belongs_to :object,    :class_name => "Node"
  belongs_to :self,      :class_name => "Node"
  validates_presence_of :subject, :predicate, :object
  validates_uniqueness_of :subject_id, :scope => [:predicate_id, :object_id]
end
