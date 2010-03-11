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

  function expectDivToContainImgMatching(divId, regExp){
    var div = E(divId);
    expect(div.childNodes.length).to(equal, 1);
    expect(div.className).to(equal, "desc");
    var img = div.childNodes[0];
    expect(img.tagName).to(equal, "IMG");
    expect(img.src).to(match, regExp);
  }

  function waitForAjax(elemId){
    var c;
    for (c=0; c < maxPollAttempts; c++){
      var elem = E(elemId);
      if (elem == null || elem.src == null ||
          elem.src.indexOf("working") == -1   )
        break;
      sleep(pollingInterval);
    }
    expect(c).to(be_lt, maxPollAttempts);
  }

  describe( "Dynamic information and checks in connections/new page",
      function(){
    describe( "connections/new behavior that doesn't need item IDs", function(){
      before(function() { IFrame("http://localhost:3001/w/connections/new"); });

      it( "has all blank item descriptions in a 'fresh' page", function(){
        var descriptionDivs = [ "subject_desc", "predicate_desc", "obj_desc" ];
        for (var c=0; c < descriptionDivs.length; c++){
          expectDivToContainImgMatching(descriptionDivs[c],
                                        /blank_status_icon\.png/);
          expect(E(descriptionDivs[c]).className).to(equal, "desc");
        }
      });
    });

    describe( "Display of descriptions for selected items", function(){
      before(function() { IFrame("http://localhost:3001/w/connections/new"); });


      it( "fetches item description when Subject selected", function(){
        expectAjaxStart("subject", "A second item");
        waitForAjax('subject_status_icon');
        expectDescriptionText("subject",
          /This category could contain anything/);
      });

      function expectAjaxStart(divName, itemTitle){
        var itemId = getItemIdByTitle(itemTitle);
        changeNamedFieldToValue('connection_' + divName + '_id', itemId);
        sleep(timeMargin);
        expectDivToContainImgMatching(divName + '_desc', /working_status_icon/);
        expect(E(divName + '_desc').className).to(equal, "desc");
      }

      function getItemIdByTitle(itemTitle){
        sel = E('connection_subject_id');
        for (var c=0; c < sel.options.length; c++){
          opt = sel.options[c];
          if ((-1 != opt.text.search(new RegExp(" : " + itemTitle + "$"))) ||
              (-1 != opt.text.search(new RegExp(" : " + itemTitle + " \\(")))   )
            return opt.value;
        }
        expect(false);  // fail if we don't find the name
      }

      function expectDescriptionText(divName, descRE){
        expect(E(divName + '_desc').innerHTML).to(match, descRE);
        expect(E(divName + '_desc').className).to(equal, "");
      }

      it( "fetches item description when Predicate selected", function(){
        expectAjaxStart("predicate", "Parent Of");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", new RegExp(
          "the subject .left-hand side. of the relationship " +
          ".+Of spacecraft.+ is a super-set"));
      });

      it( "fetches item description when Object selected", function(){
        expectAjaxStart("obj", "My first item");
        waitForAjax('obj_status_icon');
        expectDescriptionText("obj", /This item could be anything/);
      });

      it( "clears item description when missing-description item selected",
          function(){
        expectAjaxStart("subject", "testSubcategory");
        waitForAjax('subject_status_icon');
        expectDescriptionBlank("subject");
      });

      function expectDescriptionBlank(divName){
        expect(E(divName + '_desc').innerText).to(equal, "");
        expect(E(divName + '_desc').className).to(equal, "");
      }

      it( "updates item description for multiple changes", function(){
        expectAjaxStart("predicate", "Child Of");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", new RegExp(
          "This is the fundamental type of hierarchical relationship.+" +
          "A is a Child.Of B"));

        expectAjaxStart("predicate", "A");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", /A description for A/);
      });

      it( "clears item description on change-to-unselected", function(){
        expectAjaxStart("obj", "Contains");
        waitForAjax('obj_status_icon');
        expectDescriptionText("obj", /&quot;A Contains B&quot;/);

        changeNamedFieldToValue('connection_obj_id', "");
        expectDivToContainImgMatching('obj_desc', /blank_status_icon\.png/);
        expect(E('obj_desc').className).to(equal, "desc");

        expectAjaxStart("obj", "isAssigned");
        waitForAjax('obj_status_icon');
        expectDescriptionBlank("obj");
      });
    });
  });
});

