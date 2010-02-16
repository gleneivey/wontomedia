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

  describe( "Dynamic information and checks in edges/new page", function(){
    describe( "edges/new behavior that doesn't need node IDs", function(){
      before(function() { IFrame("http://localhost:3001/edges/new"); });

      it( "has all blank node descriptions in a 'fresh' page", function(){
        var descriptionDivs = [ "subject_desc", "predicate_desc", "obj_desc" ];
        for (var c=0; c < descriptionDivs.length; c++){
          expectDivToContainImgMatching(descriptionDivs[c],
                                        /blank_status_icon\.png/);
          expect(E(descriptionDivs[c]).className).to(equal, "desc");
        }
      });
    });

    describe( "Display of descriptions for selected nodes", function(){

      var nodeNamesToIdsHash = {};
      before(function(){
        IFrame("http://localhost:3001/nodes");

        var allAnchors = D().getElementsByTagName("a");
        for (var c=0; c < allAnchors.length; c++){
          var href = allAnchors[c].href;
          if (href){
            var key = allAnchors[c].innerHTML;
            mtch = href.match(/nodes\/([0-9]+)/);
            if (mtch != null && mtch.length > 0)
              nodeNamesToIdsHash[key] = mtch[1];
          }
        }

        IFrame("http://localhost:3001/edges/new");
      });


      function getNodeIdByName(nodeName){
        var nodeId = nodeNamesToIdsHash[nodeName];
        expect(nodeId).to_not(be_undefined);
        expect(nodeId).to_not(be_null);
        return nodeId;
      }

      it( "fetches node description when Subject selected", function(){
        expectAjaxStart("subject", "A second node");
        waitForAjax('subject_status_icon');
        expectDescriptionText("subject",
          /This category could contain anything/);
      });

      function expectAjaxStart(divName, nodeName){
        var nodeId = getNodeIdByName(nodeName);
        changeNamedFieldToValue('edge_' + divName + '_id', nodeId);
        sleep(timeMargin);
        expectDivToContainImgMatching(divName + '_desc',
                                      /working_status_icon/);
        expect(E(divName + '_desc').className).to(equal, "desc");
      }

      function expectDescriptionText(divName, descRE){
        expect(E(divName + '_desc').innerHTML).to(match, descRE);
        expect(E(divName + '_desc').className).to(equal, "");
      }

      it( "fetches node description when Predicate selected", function(){
        expectAjaxStart("predicate", "Parent Of");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", new RegExp(
          "the subject .left-hand side. of the relationship " +
          ".+Of spacecraft.+ is a super-set"));
      });

      it( "fetches node description when Object selected", function(){
        expectAjaxStart("obj", "My first node");
        waitForAjax('obj_status_icon');
        expectDescriptionText("obj", /This node could be anything/);
      });

      it( "clears node description when missing-description node selected",
          function(){
        expectAjaxStart("subject", "testSubcategory");
        waitForAjax('subject_status_icon');
        expectDescriptionBlank("subject");
      });

      function expectDescriptionBlank(divName){
        expect(E(divName + '_desc').innerText).to(equal, "");
        expect(E(divName + '_desc').className).to(equal, "");
      }

      it( "updates node description for multiple changes", function(){
        expectAjaxStart("predicate", "Child Of");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", new RegExp(
          "This is the fundamental type of hierarchical relationship.+" +
          "A is a Child.Of B"));

        expectAjaxStart("predicate", "A");
        waitForAjax('predicate_status_icon');
        expectDescriptionText("predicate", /A description for A/);
      });

      it( "clears node description on change-to-unselected", function(){
        expectAjaxStart("obj", "Contains");
        waitForAjax('obj_status_icon');
        expectDescriptionText("obj", /&quot;A Contains B&quot;/);

        changeNamedFieldToValue('edge_obj_id', "");
        expectDivToContainImgMatching('obj_desc', /blank_status_icon\.png/);
        expect(E('obj_desc').className).to(equal, "desc");

        expectAjaxStart("obj", "isAssigned");
        waitForAjax('obj_status_icon');
        expectDescriptionBlank("obj");
      });
    });
  });
});

