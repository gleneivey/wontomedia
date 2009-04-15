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


module AssertCurrentSchema
  def assert_current_schema
    assert_schema do |s|
      s.table "nodes" do |t|
        t.column    :id,              :integer
        t.column    :name,            :string
        t.column    :title,           :string
        t.column    :description,     :text
        t.column    :sti_type,        :string
      end

      s.table "edges" do |t|
        t.column    :id,              :integer
        t.column    :subject_id,      :integer
        t.column    :predicate_id,    :integer
        t.column    :object_id,       :integer
        t.column    :self_id,         :integer
      end

      # expect this won't be needed for future upgrade to m_t_h
      s.table "schema_migrations" do |t|
        t.column    :version,         :string
      end
    end
  end
end
