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
  before(function() { IFrame("http://localhost:3001/nodes/new"); });

  describe( "Dynamic input checks in nodes/new page", function(){
    describe( "Pre-submit check for  uniqueness of Name value", function(){

      function checkBeforeWorking(){
        // wait until just before the check should start, verify no activity
        sleep(ajaxStartsAfter - timeMargin);
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match,
          /blank_status_icon\.png/);
      }

      function checkWorkingStart(){
        // wait until after check should start, verify in-progress state
        sleep(timeMargin * 3);
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match,
          /working_status_icon/);
      }

      function waitForAjax(){
        var c;
        for (c=0; c < maxPollAttempts &&
                  E('name_status_icon').src.indexOf("working") != -1; c++)
          sleep(pollingInterval);
        expect(c).to(be_lt, maxPollAttempts);
      }

      function setNameAndCheckProgress(newNameValue, expectAjax){
        changeNamedFieldToValue('node_name', newNameValue);
        checkBeforeWorking();
        if (!expectAjax) return;
        checkWorkingStart();
        waitForAjax();
      }

      it( "flags redundant node Name strings", function(){
        setNameAndCheckProgress("peer_of", true);
        expect(E('name_must_be_unique').className).to(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match, /error_status_icon\.png/);
      });

      it("shows confirming message when node Name string is unique", function(){
        setNameAndCheckProgress("aNodeThatDoesntAlreadyExist", true);
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).to(match, /confirmationTextShow/);
        expect(E('name_status_icon').src).to(match, /good_status_icon\.png/);
      });

      it("doesn't check when Name changed to blank", function(){
        setNameAndCheckProgress("one_of", true);
        expect(E('name_status_icon').src).to(match, /error_status_icon\.png/);

        // setup done, now try clearing....
        changeNamedFieldToValue('node_name', "");

        // should happen on any change, including =""
        expect(E('name_status_icon').src).to(match, /blank_status_icon\.png/);

        // now wait long enough to be sure we didn't trigger anything...
        sleep(ajaxStartsAfter + 2*timeMargin);
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match, /blank_status_icon\.png/);
      });

      it("doesn't check if Name is invalid", function(){
        setNameAndCheckProgress("0: bad Name!", false);

        // wait until after check would have started,
        sleep(timeMargin * 3);

        // verify not in progress
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match, /blank_status_icon\.png/);
      });

      it( "performs check after node.Title set, node_title.blur()", function(){
        E('node_sti_type').value = "ItemNode";
        changeNamedFieldToValue('node_title', "another new node");
        E('node_description').focus();

        checkBeforeWorking();
        checkWorkingStart();
        waitForAjax();

        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).to(match, /confirmationTextShow/);
        expect(E('name_status_icon').src).to(match, /good_status_icon\.png/);
      });

/*
      it( "clears Name string confirmation on user node.Name change ",
        function(){

      });

      it( "clears Name string confirmation on auto-gen node.Name change ",
        function(){

      });

      it( "doesn't start new check if node.Name contents same", function(){

      });

      it( "abandons check if node.Name changed before complete", function(){

      });
*/
    });
  });
});

