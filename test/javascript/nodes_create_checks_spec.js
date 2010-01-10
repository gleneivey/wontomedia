// WontoMedia - a wontology web application
// Copyright (C) 2010 - Glen E. Ivey
//    www.wontology.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License version
// 3 as published by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program in the file COPYING and/or LICENSE.  If not,
// see <http://www.gnu.org/licenses/>.


require("spec_helper.js");


Screw.Unit(function(){
  before(function() { IFrame("http://localhost:3001/nodes/new"); });

  var titleIds = [ 'category_title', 'item_title', 'property_title' ];
  var descIds  = [ 'category_desc', 'item_desc', 'property_desc' ];

  describe( "Dynamic input checks in nodes/new page", function(){
    describe( "Visual feedback for Type selection", function(){
      it( "'Fresh' page has no descriptive text highlighted", function(){
        var sel = E('node_sti_type');

        // at the beginning, no items highlighted
        for (var c=0; c < titleIds.length; c++){
          expect(E(titleIds[c]).className).
            to_not(match, /titleSelectedItemDescription/);
          expect(E(descIds[c]).className).
            to_not(match, /bodySelectedItemDescription/);
        }
      });

      it( "Node-type selection highlights matching text", function(){
        var nodeTypeValue = [ 'ClassNode', 'ItemNode', 'PropertyNode' ];
        var testSequence = [ 0, 1, 2, 0, 1, 2, 1, 0, 2 ];

        for (var c=0; c < testSequence.length; c++){
          var seq = testSequence[c];

          // select a node type...
          changeNamedFieldToValue('node_sti_type', nodeTypeValue[seq]);
          // ...and the text for that node type gets highlighted,
          expect(E(titleIds[seq]).className).
            to(match, /titleSelectedItemDescription/);
          expect(E(descIds[seq]).className).
            to(match, /bodySelectedItemDescription/);

          // and the other descriptive text is un-highlighted
          for (var cn=0; cn < titleIds.length; cn++){

            if (seq != cn){
              expect(E(titleIds[cn]).className).
                to_not(match, /titleSelectedItemDescription/);
              expect(E(descIds[cn]).className).
                to_not(match, /bodySelectedItemDescription/);
            }
          }
        }
      });
    });
  });
});

