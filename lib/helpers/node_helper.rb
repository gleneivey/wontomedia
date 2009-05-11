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
  NODE_CLASSNAME_TO_SUBTYPE_SHORT = { 
    "ClassNode" => 'class', "ItemNode" => 'item',
    "PropertyNode" => 'property', "ReiffiedNode" => 'reiffied'
  }
  NODE_SUBTYPES_TO_HUMAN = {
    'ClassNode' => 'Category',
    'ItemNode' => 'Item',
    'PropertyNode' => 'Property Type',
    'ReiffiedNode' => 'Reiffied Property'
  }

  def self.find_typed_node(*args)
    n = Node.find(*args)
    if n.nil?                                  ||
       n.sti_type.nil?                         ||
       NODE_SUBTYPES_FROM_TEXT[n.sti_type].nil?
      return nil
    end

    klass = case n.sti_type
            when "Node"              then Node
            when "node"              then Node
            when "ClassNode"         then ClassNode
            when "class"             then ClassNode
            when "ItemNode"          then ItemNode
            when "item"              then ItemNode
            when "PropertyNode"      then PropertyNode
            when "property"          then PropertyNode
            when "ReiffiedNode"      then ReiffiedNode
            when "reiffied-property" then ReiffiedNode
            end
#    NODE_SUBTYPES_FROM_TEXT[n.sti_type].find(*args)
    klass.find(*args)
  end

  def self.new_typed_node(type_string, *args)
    if type_string.nil?
      return nil
    end
    if NODE_SUBTYPES_FROM_TEXT[type_string].nil?
      type_string = type_string.singularize
      if NODE_SUBTYPES_FROM_TEXT[type_string].nil?
        return nil
      end
    end

# absolutely no idea why this ugly thing works, but simply hash lookup
# below causes failure deep in Rails' guts during new()
    klass = case type_string
            when "Node"              then Node
            when "node"              then Node
            when "ClassNode"         then ClassNode
            when "class"             then ClassNode
            when "ItemNode"          then ItemNode
            when "item"              then ItemNode
            when "PropertyNode"      then PropertyNode
            when "property"          then PropertyNode
            when "ReiffiedNode"      then ReiffiedNode
            when "reiffied-property" then ReiffiedNode
            end
#    klass = NODE_SUBTYPES_FROM_TEXT[type_string]
    klass.new(*args)
  end

  def self.node_to_hash(n)
      # again, I ought to be able to make the list programatically....
    { :id => n.id, :name => n.name, :title => n.title,
      :description => n.description, :sti_type => n.sti_type }
  end

  def self.nouns
    ClassNode.all + ItemNode.all
  end
end
