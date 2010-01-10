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


      var submitName = 'node_submit';
      var nodeCreationElements = [ 'node_sti_type', 'node_title',
                                   'node_name', 'node_description',
                                   submitName ];

      var selectName;
      it( "allows creation of a Predicate node in edges/new page", function(){
        selectName = 'edge_predicate_id';
        expectPopupTriggering();
        var formStrings = [ "PropertyNode", "new property for JS testing",
                            "newProperty",
                            "A property-type node for testing of popup JS" ];
        fillInPopupForm( formStrings, "newPropertyForJsTesting" );
        var nodeRE = expectEdgeUpdateOnPopupSubmission('predicate', formStrings);
        expectSelectContentForVerb(nodeRE);
      });
      it( "allows creation of a Object node in edges/new page", function(){
        selectName = 'edge_obj_id';
        expectPopupTriggering();
        var formStrings = [ "ClassNode", "new category", "newCatNode",
                            "A category-type node for testing of popup JS" ];
        fillInPopupForm( formStrings, "NewCategory" );
        var nodeRE = expectEdgeUpdateOnPopupSubmission('obj', formStrings);
        expectSelectContentForNoun(nodeRE);
      });
      it( "allows creation of a Subject node in edges/new page", function(){
        selectName = 'edge_subject_id';
        expectPopupTriggering();
        var formStrings = [ "ItemNode", "new node for JS testing", "newJsNode",
                            "A node for testing of popup JS" ];
        fillInPopupForm( formStrings, "NewNodeForJsTesting" );
        var nodeRE = expectEdgeUpdateOnPopupSubmission('subject', formStrings);
        expectSelectContentForNoun(nodeRE);
      });




      function expectPopupTriggering(){
        changeNamedFieldToValue(selectName, magicSelectValue);
        waitForAjaxCreatedElement(submitName);

        for (var c=0; c < nodeCreationElements.length; c++)
          expect(E(nodeCreationElements[c])).to_not(equal, null);
        expect(E(submitName).className).to(match, /^inactiveButton/);
      }

      function fillInPopupForm(inStrs, nameCheck){
        var submit = E(submitName);

        // loop index: type, title, name, description
        for (var c=0; c < inStrs.length; c++){

          if (inStrs[c])
            changeNamedFieldToValue(nodeCreationElements[c], inStrs[c]);

          expect(submit.className).to(match,
            (c == 0) ? /^inactiveButton/ : /^activeButton/);

          if (c == 1 && nameCheck)
            expect(E(nodeCreationElements[2]).value).to(
              equal, nameCheck);
        }

        expectGoodAjaxCheckForUniqueName();
      }

      function expectEdgeUpdateOnPopupSubmission(elemName, formStrs){
        E(submitName).click();
        var nodeRE = (
          waitForAjaxUpdatedSelection(selectName, formStrs[1], formStrs[2]) );
        var descRE = new RegExp(formStrs[3]);
        waitForAjaxCondition(function(){
          return E(elemName + '_desc').innerText.match(descRE);
        });
        return nodeRE;
      }

      function expectSelectContentForNoun(nodeRE){
        expectSelectContent_Generic(nodeRE, true);
      }
      function expectSelectContentForVerb(nodeRE){
        expectSelectContent_Generic(nodeRE, false);
      }
      function expectSelectContent_Generic(nodeRE, checkForNoun){
        var opt;
        opt = optionOfElementMatchingRe(E('edge_subject_id'), nodeRE);
        expect(opt).to_not(be_null);
        opt = optionOfElementMatchingRe(E('edge_predicate_id'), nodeRE);
        if (checkForNoun)
          expect(opt).to(be_null);
        else
          expect(opt).to_not(be_null);
        opt = optionOfElementMatchingRe(E('edge_obj_id'), nodeRE);
        expect(opt).to_not(be_null);

        var newNodesId = opt.value;
        expect(E(selectName).value).to(equal, newNodesId);
      }

      function expectGoodAjaxCheckForUniqueName(){
        waitForAjaxCondition(function(){
          return (
            E('name_is_unique').className.match(/confirmationTextShow/) &&
            E('name_status_icon').src.match(/good_status_icon/)
          );
        });
      }

      function waitForAjaxCreatedElement(elemId){
        waitForAjaxCondition(function(){
          return (E(elemId) != null);
        });
      }

      function waitForAjaxUpdatedSelection(selectName, title, name){
        var nodeRE = new RegExp("^" + name + " : " + title + "$");
        waitForAjaxCondition(function(){
          return (optionOfElementMatchingRe(E(selectName), nodeRE) != null);
        });
        sleep(5*pollingInterval);   // modalbox needs time to process....
        return nodeRE;
      }


      function waitForAjaxCondition(conditionFn){
        var c;
        for (c=0; c < maxPollAttempts; c++){
          if (conditionFn()) break;
          sleep(pollingInterval);
        }
        expect(c).to(be_lt, maxPollAttempts);
      }

      function optionOfElementMatchingRe(selectElem, regExp){
        for (var c=0;c < selectElem.options.length; c++)
          if (selectElem.options[c].text.match(regExp))
            return selectElem.options[c];
        return null;
      }
    });
  });
});

