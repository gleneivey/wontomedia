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


class NodeHelper
  NODE_SUBTYPES_FROM_TEXT = { 
    "node" => Node, "class" => ClassNode, "item" => ItemNode,
    "property" => PropertyNode, "reiffied-property" => ReiffiedNode
  }
  NODE_SUBTYPES_TO_CLASSNAME = { 
    ClassNode => 'class', ItemNode => 'item',
    PropertyNode => 'property', ReiffiedNode => 'reiffied'
  }

  def self.make_typed_node(source_node, type_string)
    new_node = NODE_SUBTYPES[type_string].new
      # FIXME: OK, the following sucks.  I'm sure there's a way to
      # get the list of attributes from an ActiveRecord type, and then
      # itterate over them and use .send or something....  But, too
      # lazy to find it right now
    new_node.id          = source_node.id
    new_node.name        = source_node.name
    new_node.title       = source_node.title
    new_node.description = source_node.description
  end

  def self.nouns
    ClassNode.all + ItemNode.all
  end
end
