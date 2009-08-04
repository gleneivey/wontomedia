// WontoMedia - a wontology web application
// Copyright (C) 2009 - Glen E. Ivey
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
  describe( "Dynamic input checks in nodes/new page", function(){
    describe( "Visual feedback for Type selection", function(){
      it( "'Fresh' page has no descriptive text highlighted", function(){
        var d = document.getElementById('test_frame').contentDocument;
        var sel = d.getElementById('node_sti_type');

        var titleIds = [ 'category_title', 'item_title', 'property_title' ];
        var descIds  = [ 'category_desc', 'item_desc', 'property_desc' ];

        // at the beginning, no items highlighted
        for (var c=0; c < titleIds.length; c++){
          expect(d.getElementById(titleIds[c]).className).
            to_not(match, /titleSelectedItemDescription/);
          expect(d.getElementById(descIds[c]).className).
            to_not(match, /bodySelectedItemDescription/);
        }
      });

      it( "Node-type selection highlights matching text", function(){
        var d = document.getElementById('test_frame').contentDocument;
        var sel = d.getElementById('node_sti_type');

        var nodeTypeValue = [ 'ClassNode', 'ItemNode', 'PropertyNode' ];
        var titleIds = [ 'category_title', 'item_title', 'property_title' ];
        var descIds  = [ 'category_desc', 'item_desc', 'property_desc' ];

        var testSequence = [ 0, 1, 2, 0, 1, 2, 1, 0, 2 ];

        for (var c=0; c < testSequence.length; c++){
          var seq = testSequence[c];

          // select a node type...
          sel.focus();
          sel.value = nodeTypeValue[seq];
          sel.blur();                // needed to trigger SELECT.onchange

          // ...and the text for that node type gets highlighted,
          expect(d.getElementById(titleIds[seq]).className).
            to(match, /titleSelectedItemDescription/);
          expect(d.getElementById(descIds[seq]).className).
            to(match, /bodySelectedItemDescription/);

          // and the other descriptive text is un-highlighted
          for (var cn=0; cn < titleIds.length; cn++){

            if (seq != cn){
              expect(d.getElementById(titleIds[cn]).className).
                to_not(match, /titleSelectedItemDescription/);
              expect(d.getElementById(descIds[cn]).className).
                to_not(match, /bodySelectedItemDescription/);
            }
          }
        }
      });
    });
  });
});

