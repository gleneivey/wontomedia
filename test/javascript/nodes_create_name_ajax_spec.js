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
  ajaxStartsAfter = 400;  // milliseconds
  timeMargin      =  50;
  pollingInterval =  10;
  maxPollAttempts =  30;  // iterations

  describe( "Dynamic input checks in nodes/new page", function(){
    describe( "Pre-submit check for  uniqueness of Name value", function(){

      function setNameAndCheckProgress(newNameValue){
        var d = document.getElementById('test_frame').contentDocument;
        var name = d.getElementById('node_name');

        name.focus();
        name.value = newNameValue;
        name.blur();

        // wait until just before the check should start, verify no activity
        java.lang.Thread.currentThread().sleep(ajaxStartsAfter - timeMargin);
        expect(d.getElementById('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(d.getElementById('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(d.getElementById('name_status_icon').src).to(match,
          /blank_status_icon\.png/);

        // wait until after check should start, verify in-progress state
        java.lang.Thread.currentThread().sleep(timeMargin * 3);
        expect(d.getElementById('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(d.getElementById('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(d.getElementById('name_status_icon').src).to(match,
          /working_status_icon\.png/);

        // now wait for Ajax operation to complete
        icon = d.getElementById('name_status_icon');
        for (var c=0;
             c < maxPollAttempts && icon.src.indexOf("working") != -1;
             c++)
          java.lang.Thread.currentThread().sleep(50);
        expect(c).to(be_lt, maxPollAttempts);
      }

      it( "flags redundant node Name strings", function(){
        setNameAndCheckProgress("peer_of");

        var d = document.getElementById('test_frame').contentDocument;
        expect(d.getElementById('name_must_be_unique').className).
          to(match, /helpTextFlagged/);
        expect(d.getElementById('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(d.getElementById('name_status_icon').src).to(match,
          /error_status_icon\.png/);
      });

      it("shows confirming message when node Name string is unique", function(){
        setNameAndCheckProgress("aNodeThatDoesntAlreadyExist");

        var d = document.getElementById('test_frame').contentDocument;
        expect(d.getElementById('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(d.getElementById('name_is_unique').className).
          to(match, /confirmationTextShow/);
        expect(d.getElementById('name_status_icon').src).to(match,
          /good_status_icon\.png/);
      });

      it("doesn't check when Name changed to blank", function(){
        var d = document.getElementById('test_frame').contentDocument;
        var name = d.getElementById('node_name');

        setNameAndCheckProgress("one_of");
        expect(d.getElementById('name_status_icon').src).to(match,
          /error_status_icon\.png/);

        // setup done, now try clearing....
        name.focus();
        name.value = "";
        name.blur();

        // should happen on any change, including =""
        expect(d.getElementById('name_status_icon').src).to(match,
          /blank_status_icon\.png/);

        // now wait long enough to be sure we didn't trigger anything...
        java.lang.Thread.currentThread().sleep(ajaxStartsAfter + 2*timeMargin);
        expect(d.getElementById('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(d.getElementById('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(d.getElementById('name_status_icon').src).to(match,
          /blank_status_icon\.png/);
      });

/*
      it("doesn't check if Name is invalid", function(){

      });

      it( "delays starting check after node.Name onchange", function(){

      });

      it( "delays starting check after node.Name onkeypress", function(){

      });

      it( "starts check after in-page focus change", function(){

      });

      it( "performs check after node.Title set, node_title.blur()", function(){

      });

      it( "clears Name string confirmation on node.Name change ", function(){

      });

      it( "doesn't start new check if node.Name contents same", function(){

      });

      it( "abandons check if node.Name changed before complete", function(){

      });
*/
    });
  });
});

