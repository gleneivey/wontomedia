# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
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


require File.join( File.dirname(__FILE__), 'test_helper' )

module AssertCurrentSchema
  def assert_current_schema
    assert_schema do |s|
      s.table "items" do |t|
        t.column    :id,              :integer
        t.column    :name,            :string
        t.column    :title,           :string
        t.column    :description,     :text
        t.column    :sti_type,        :string
        t.column    :flags,           :integer, :null => false, :default => 0
        t.column    :created_at,      :datetime
        t.column    :updated_at,      :datetime
      end

      s.table "connections" do |t|
        t.column    :id,                 :integer
        t.column    :subject_id,         :integer
        t.column    :predicate_id,       :integer
        t.column    :obj_id,             :integer
        t.column    :scalar_obj,         :string
        t.column    :kind_of_obj,        :string
        t.column    :connection_desc_id, :integer
        t.column    :flags,              :integer, :null => false, :default => 0
        t.column    :created_at,         :datetime
        t.column    :updated_at,         :datetime
      end
    end
  end
end
