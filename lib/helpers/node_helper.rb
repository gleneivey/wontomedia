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
    "node"              => Node,         "Node"         => Node,
    "class"             => ClassNode,    "ClassNode"    => ClassNode,
    "item"              => ItemNode,     "ItemNode"     => ItemNode,
    "property"          => PropertyNode, "PropertyNode" => PropertyNode,
    "reiffied-property" => ReiffiedNode, "ReiffiedNode" => ReiffiedNode
  }
  NODE_SUBTYPES_TO_CLASSNAME = { 
    ClassNode => 'class', ItemNode => 'item',
    PropertyNode => 'property', ReiffiedNode => 'reiffied'
  }
  NODE_SUBTYPES_TO_HUMAN = {
    'ClassNode' => 'Category',             ClassNode => 'Category',
    'ItemNode' => 'Item',                  ItemNode => 'Item',
    'PropertyNode' => 'Property Type',     PropertyNode => 'Property Type',
    'ReiffiedNode' => 'Reiffied Property', ReiffiedNode => 'Reiffied Property'
  }

  def self.find_typed_node(type_string, *args)
    if NODE_SUBTYPES_FROM_TEXT[type_string].nil?
      return nil
    end
    NODE_SUBTYPES_FROM_TEXT[type_string].find(*args)
  end

  def self.new_typed_node(type_string, a_hash)
    if NODE_SUBTYPES_FROM_TEXT[type_string].nil?
      return nil
    end

    case type_string
    when 'ClassNode' then ClassNode.new(a_hash)
    when 'ItemNode'  then ItemNode.new(a_hash)
    when 'PropertyNode' then PropertyNode.new(a_hash)
    when 'ReiffiedNode' then ReiffiedNode.new(a_hash)
    end
#    NODE_SUBTYPES_FROM_TEXT[type_string].send :new, a_hash
  end

  def self.make_typed_node(source_node, type_string)
    if NODE_SUBTYPES_FROM_TEXT[type_string].nil?
      return nil
    end

    new_node = NODE_SUBTYPES_FROM_TEXT[type_string].new
      # FIXME: OK, the following sucks.  I'm sure there's a way to
      # get the list of attributes from an ActiveRecord type, and then
      # iterate over them and use .send or something....  But, too
      # lazy to find it right now
    new_node.id          = source_node.id
    new_node.name        = source_node.name
    new_node.title       = source_node.title
    new_node.description = source_node.description
    new_node
  end

  def self.node_to_hash(n)
      # again, I ought to be able to make the list programatically....
    { :id => n.id, :name => n.name, :title => n.title,
      :description => n.description, :type => n.type }
  end

  def self.nouns
    ClassNode.all + ItemNode.all
  end
end
