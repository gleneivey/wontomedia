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
          var mtch = allAnchors[c].innerHTML.match(/^([a-zA-Z][a-zA-Z0-9_-]*)/);
          if (href != null && href != "" &&
              mtch != null && mtch.length > 1){
            var key = mtch[1];
            mtch = href.match(/nodes\/([0-9]+)/);
            if (mtch != null && mtch.length > 0)
              nodeNamesToIdsHash[key] = mtch[1];
          }
        }

        IFrame("http://localhost:3001/edges/new");
      });


      function getNodeIdByName(nodeName){
        return nodeNamesToIdsHash[nodeName];
      }

      it( "fetches node description when Subject selected", function(){
        var nodeId = getNodeIdByName("bNode");
        changeNamedFieldToValue('edge_subject_id', nodeId);
        sleep(timeMargin);
        expectDivToContainImgMatching('subject_desc',
                                      /working_status_icon\.png/);
        expect(E('subject_desc').className).to(equal, "desc");

        waitForAjax('subject_status_icon');
        expect(E('subject_desc').innerHTML).to(match,
          /This category could contain anything/);
        expect(E('subject_desc').className).to(equal, "");
      });

      it( "fetches node description when Predicate selected", function(){
        var nodeId = getNodeIdByName("parent_of");
        changeNamedFieldToValue('edge_predicate_id', nodeId);
        sleep(timeMargin);
        expectDivToContainImgMatching('predicate_desc',
                                      /working_status_icon\.png/);
        expect(E('predicate_desc').className).to(equal, "desc");

        waitForAjax('predicate_status_icon');
        var matchText = "the subject .left-hand side. of the relationship " +
          ".+Of spacecraft.+ is a super-set";
        expect(E('predicate_desc').innerHTML).to(match, new RegExp(matchText));
        expect(E('predicate_desc').className).to(equal, "");
      });

      it( "fetches node description when Object selected", function(){
        var nodeId = getNodeIdByName("aNode");
        changeNamedFieldToValue('edge_obj_id', nodeId);
        sleep(timeMargin);
        expectDivToContainImgMatching('obj_desc',
                                      /working_status_icon\.png/);
        expect(E('obj_desc').className).to(equal, "desc");

        waitForAjax('obj_status_icon');
        expect(E('obj_desc').innerHTML).to(match,
          /This node could be anything/);
        expect(E('obj_desc').className).to(equal, "");
      });
    });
  });
});

