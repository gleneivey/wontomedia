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
  before(function() { IFrame("http://localhost:3001/w/items/new"); });

  describe( "Dynamic input checks in items/new page", function(){
    describe( "Pre-submit check for  uniqueness of Name value", function(){

      it( "flags redundant item Name strings", function(){
        setNameAndCheckProgress("peer_of", true);
        expectIndicatorsForAlreadyUsed();
      });

      it("shows confirming message when item Name string is unique", function(){
        setNameAndCheckProgress("aItemThatDoesntAlreadyExist", true);
        expectIndicatorsForUnique();
      });

      it( "clears Name string confirmation on user item.Name change ",
        function(){

        setNameAndCheckProgress("anotherNewItem", true);
        expectIndicatorsForUnique();
        changeNamedFieldToValue('item_name', "orAnotherNewItem");
        expectIndicatorsForNocheck();
      });

      it("doesn't check when Name changed to blank", function(){
        setNameAndCheckProgress("one_of", true);
        expectIndicatorsForAlreadyUsed();

        // setup done, now try clearing....
        changeNamedFieldToValue('item_name', "");

        // should happen on any change, including =""
        expectIndicatorsForNocheck();

        // now wait long enough to be sure we didn't trigger anything...
        sleep(ajaxStartsAfter + 2*timeMargin);
        expectIndicatorsForNocheck();
      });

      it("doesn't check if Name is invalid", function(){
        setNameAndCheckProgress("0: bad Name!", false);

        // wait until after check would have started,
        sleep(timeMargin * 3);

        // verify not in progress
        expectIndicatorsForNocheck();
      });

      it( "doesn't check if Name 'changed' to same contents", function(){
        setNameAndCheckProgress("newItemX", true);
        expectIndicatorsForUnique();
        // setup done, now "change" to same value
        changeNamedFieldToValue('item_name', "newItemX");
        expectIndicatorsForUnique();
        sleep(ajaxStartsAfter + 2*timeMargin);
        expectIndicatorsForUnique();
      });

      it( "abandons check if Name changed before complete", function(){
        setNameAndCheckProgress("newItemY", true);
        expectIndicatorsForUnique();

        // change to a different value
        changeNamedFieldToValue('item_name', "parent_of");
        checkBeforeWorking();
        checkWorkingStart();

        // now that we've started checking the last, change again
        var nameIconImg = E('name_status_icon');
        var countOfErrorIconDisplays = 0;
        nameIconImg.onload = function(){
          if (nameIconImg.src.match(/error_status_icon/))
            countOfErrorIconDisplays++;
        };
        setNameAndCheckProgress("newItemZ", true);
        expectIndicatorsForUnique();
        expect(countOfErrorIconDisplays).to(equal, 0);
      });

      it( "performs check after item.Title set, item_title.blur()", function(){
        E('item_sti_type').value = "IndividualItem";
        changeNamedFieldToValue('item_title', "another new item");

        checkBeforeWorking();
        checkWorkingStart();
        waitForAjax();
        expectIndicatorsForUnique();
      });

      it( "clears Name string confirmation on auto-gen item.Name change ",
        function(){

        // setup
        E('item_sti_type').value = "IndividualItem";
        var title = E('item_title');
        var name = E('item_name');

        // start entering a Title, which will auto-generate a Name
        changeFieldToValue(title, "start of title");
        checkBeforeWorking();
        checkWorkingStart();
        waitForAjax();

        // extend Title, will regenerate Name, should clear "unique" flags
        changeFieldToValue(title, "start of title-end of title");
        expectIndicatorsForNocheck();
      });

      function setNameAndCheckProgress(newNameValue, expectAjax){
        changeNamedFieldToValue('item_name', newNameValue);
        checkBeforeWorking();
        if (!expectAjax) return;
        checkWorkingStart();
        waitForAjax();
      }

      function checkBeforeWorking(){
        // wait until just before the check should start, verify no activity
        sleep(ajaxStartsAfter - (2*timeMargin));
        expectIndicatorsForNocheck();
      }

      function checkWorkingStart(){
        // wait until after check should start, verify in-progress state
        sleep(timeMargin * 3);
        expectIndicatorsForWorking();
      }

      function waitForAjax(){
        var c;
        for (c=0; c < maxPollAttempts &&
                  E('name_status_icon').src.indexOf("working") != -1; c++)
          sleep(pollingInterval);
        expect(c).to(be_lt, maxPollAttempts);
      }

      function expectIndicatorsForUnique(){
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).to(match, /confirmationTextShow/);
        expect(E('name_status_icon').src).to(match, /good_status_icon\.png/);
      }

      function expectIndicatorsForAlreadyUsed(){
        expect(E('name_must_be_unique').className).to(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match, /error_status_icon\.png/);
      }

      function expectIndicatorsForNocheck(){
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match, /blank_status_icon\.png/);
      }

      function expectIndicatorsForWorking(){
        expect(E('name_must_be_unique').className).
          to_not(match, /helpTextFlagged/);
        expect(E('name_is_unique').className).
          to(match, /confirmationTextInvisible/);
        expect(E('name_status_icon').src).to(match,
          /working_status_icon/);
      }
    });
  });
});

