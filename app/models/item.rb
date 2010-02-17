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


class Item < ActiveRecord::Base
  DATA_IS_UNALTERABLE = 1


  self.inheritance_column = "sti_type"

    # name
  validates_presence_of   :name, :message => "Item's name cannot be blank."
  validates_length_of     :name, :maximum => 80,
    :message => "Item name must be 80 characters or less."
  validates_each          :name do |record, attr, value|
    if !(value =~ /^[a-zA-Z][a-zA-Z0-9._:-]*$/m) ||
        (value =~ /\n/m)
      record.errors.add attr, "must start with a letter, and can contain only"\
        "letters, numbers, and/or the period, colon, dash, and underscore."
    end
  end
  validates_uniqueness_of :name, :message =>
    "There is already a item with the same name."

    # title
  validates_presence_of   :title, :message => "Item's title cannot be blank."
  validates_length_of     :title, :maximum => 255,
    :message => "Item title must be 255 characters or less."
  validates_each          :title do |record, attr, value|
    if value =~ /[\n\t]/m
      record.errors.add attr, "should not be multiple lines."
    end
  end

  validates_length_of     :description, :maximum => 65000,
    :allow_nil => true, :allow_blank => true,
    :message => "Item description must be 65,000 characters or less."



  # hack to provide default; alternative @ http://blog.phusion.nl/2008/10/03/47/
  def flags
    self[:flags] or 0
  end
end
