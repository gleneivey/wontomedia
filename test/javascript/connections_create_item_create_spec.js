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

  describe( "Dynamic information and checks in connections/new page",
      function(){
    describe( "connections/new has popup new item creation", function(){
      before(function() { IFrame("http://localhost:3001/connections/new"); });

      it( "has items/new option in all three SELECTs", function(){
        var selectors = [ 'connection_subject_id', 'connection_predicate_id',
          'connection_obj_id' ];
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


      var submitName = 'item_submit';
      var itemCreationElements = [ 'item_sti_type', 'item_title',
        'item_name', 'item_description', submitName ];

      var selectName;
      it( "allows creation of a Predicate item in connections/new page",
          function(){
        selectName = 'connection_predicate_id';
        expectPopupTriggering();
        var formStrings = [ "PropertyItem", "new property for JS testing",
          "newProperty", "A property-type item for testing of popup JS" ];
        fillInPopupForm( formStrings, "newPropertyForJsTesting" );
        var itemRE = expectConnectionUpdateOnPopupSubmission('predicate',
          formStrings);
        expectSelectContentForVerb(itemRE);
      });
      it( "allows creation of a Object item in connections/new page",
          function(){
        selectName = 'connection_obj_id';
        expectPopupTriggering();
        var formStrings = [ "CategoryItem", "new category", "newCatItem",
          "A category-type item for testing of popup JS" ];
        fillInPopupForm( formStrings, "NewCategory" );
        var itemRE = expectConnectionUpdateOnPopupSubmission('obj',
          formStrings);
        expectSelectContentForNoun(itemRE);
      });
      it( "allows creation of a Subject item in connections/new page",
          function(){
        selectName = 'connection_subject_id';
        expectPopupTriggering();
        var formStrings = [ "IndividualItem", "new item for JS testing",
                            "newJsItem", "A item for testing of popup JS" ];
        fillInPopupForm( formStrings, "NewItemForJsTesting" );
        var itemRE = expectConnectionUpdateOnPopupSubmission('subject',
          formStrings);
        expectSelectContentForNoun(itemRE);
      });




      function expectPopupTriggering(){
        changeNamedFieldToValue(selectName, magicSelectValue);
        waitForAjaxCreatedElement(submitName);

        for (var c=0; c < itemCreationElements.length; c++)
          expect(E(itemCreationElements[c])).to_not(equal, null);
        expect(E(submitName).className).to(match, /^inactiveButton/);
      }

      function fillInPopupForm(inStrs, nameCheck){
        var submit = E(submitName);

        // loop index: type, title, name, description
        for (var c=0; c < inStrs.length; c++){

          if (inStrs[c])
            changeNamedFieldToValue(itemCreationElements[c], inStrs[c]);

          expect(submit.className).to(match,
            (c == 0) ? /^inactiveButton/ : /^activeButton/);

          if (c == 1 && nameCheck)
            expect(E(itemCreationElements[2]).value).to(
              equal, nameCheck);
        }

        expectGoodAjaxCheckForUniqueName();
      }

      function expectConnectionUpdateOnPopupSubmission(elemName, formStrs){
        E(submitName).click();
        var itemRE = (
          waitForAjaxUpdatedSelection(selectName, formStrs[1], formStrs[2]) );
        var descRE = new RegExp(formStrs[3]);
        waitForAjaxCondition(function(){
          return E(elemName + '_desc').innerText.match(descRE);
        });
        return itemRE;
      }

      function expectSelectContentForNoun(itemRE){
        expectSelectContent_Generic(itemRE, true);
      }
      function expectSelectContentForVerb(itemRE){
        expectSelectContent_Generic(itemRE, false);
      }
      function expectSelectContent_Generic(itemRE, checkForNoun){
        var opt;
        opt = optionOfElementMatchingRe(E('connection_subject_id'), itemRE);
        expect(opt).to_not(be_null);
        opt = optionOfElementMatchingRe(E('connection_predicate_id'), itemRE);
        if (checkForNoun)
          expect(opt).to(be_null);
        else
          expect(opt).to_not(be_null);
        opt = optionOfElementMatchingRe(E('connection_obj_id'), itemRE);
        expect(opt).to_not(be_null);

        var newItemsId = opt.value;
        expect(E(selectName).value).to(equal, newItemsId);
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
        var itemRE = new RegExp("^" + name + " : " + title + "$");
        waitForAjaxCondition(function(){
          return (optionOfElementMatchingRe(E(selectName), itemRE) != null);
        });
        sleep(5*pollingInterval);   // modalbox needs time to process....
        return itemRE;
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

