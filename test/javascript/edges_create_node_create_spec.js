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

  var magicSelectValue = "-1";

  describe( "Dynamic information and checks in edges/new page", function(){
    describe( "edges/new has popup new node creation", function(){
      before(function() { IFrame("http://localhost:3001/edges/new"); });

      it( "has nodes/new option in all three SELECTs", function(){
        var selectors = [ 'edge_subject_id', 'edge_predicate_id',
                          'edge_obj_id' ];
        var popupOptionCount = 0;
        for (var c=0; c < selectors.length; c++){
          var selectElem = E(selectors[c]);
          for (var cn=0; cn < selectElem.length; cn++)
            if (selectElem.options[cn].text.match(/^- .+new.+for this/)){
              popupOptionCount++;
              break;
            }
        }

        expect(popupOptionCount).to(equal, selectors.length);
      });


      it( "allows creation of a node from within edges/new page", function(){
        var submitName = 'node_submit';

        changeNamedFieldToValue('edge_subject_id', magicSelectValue);
        waitForAjaxCreatedElement(submitName);

        var nodeCreationElements = [ 'node_sti_type', 'node_title',
                                     'node_name', 'node_description',
                                     submitName ];
        for (var c=0; c < nodeCreationElements.length; c++)
          expect(E(nodeCreationElements[c])).to_not(equal, null);

        var submit = E(submitName);
        expect(submit.className).to(match, /^inactiveButton/);

        // node.sti_type
        changeNamedFieldToValue(nodeCreationElements[0], "ItemNode");
        expect(submit.className).to(match, /^inactiveButton/);

        // node.title
        changeNamedFieldToValue(nodeCreationElements[1],
          "new node for JS testing");
        expect(submit.className).to(match, /^activeButton/);
        expect(E(nodeCreationElements[2]).value).to(
          equal, "NewNodeForJsTesting");

        // node.name
        changeNamedFieldToValue(nodeCreationElements[2], "newJsNode");
        expect(submit.className).to(match, /^activeButton/);

        // node.description
        changeNamedFieldToValue(nodeCreationElements[3],
          "A node for testing of popup JS");
        expect(submit.className).to(match, /^activeButton/);

        waitForAjaxCondition(function(){
          return (
            E('name_is_unique').className.match(/confirmationTextShow/) &&
            E('name_status_icon').src.match(/good_status_icon/)
          );
        });

        submit.click();
      });

      function waitForAjaxCreatedElement(elemId){
        waitForAjaxCondition(function(){
          return (E(elemId) != null);
        });
      }

      function waitForAjaxCondition(conditionFn){
        var c;
        for (c=0; c < maxPollAttempts; c++){
          if (conditionFn()) break;
          sleep(pollingInterval);
        }
        expect(c).to(be_lt, maxPollAttempts);
        sleep(5*pollingInterval);   // modalbox needs time to process....
      }
    });
  });
});

