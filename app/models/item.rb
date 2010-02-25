#--
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
#++


# Model for the representation of "items" (things that can be related
# to each other through "connections") in WontoMedia's database.  The
# schema listing the data fields for an Item is, of course, in
# db/schema.rb.  And Rails' automatically-provided model methods are
# based on the field names there.
#
# WontoMedia uses Rails' "single-table inheritance" to create several
# specialized types of Item objects, all of which are stored in the
# same database table together.  The type of object a particular table
# row represents is determined by that object's <tt>sti_type</tt>
# field.  There are a number of constants and methods in the module
# ItemHelper that can be used load or evaluate +sti_type+ and to
# perform generic operations on Item instances that correctly preserve
# their child class.
#
# A great deal of this model's behavior is provided through Rails
# validation methods (<tt>validates_...</tt>), see the source for
# details.
class Item < ActiveRecord::Base

  # This constant is a bit mask for Item.flags.  A non-zero value
  # indicates that the Item instance should not be user-modifiable.
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



  # This method is a hack to provide a legitimate default value for
  # the +flags+ field of an Item that hasn't been initialized yet.
  # Alternative at http://blog.phusion.nl/2008/10/03/47/
  def flags #:nodoc:
    # Note that the default value returned here must/does match the
    # column default specified in the database schema
    self[:flags] or 0
  end
end
