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
    describe( "Validation of input to Title and Name", function(){
      it( "Checks the Title field for newlines", function(){
        var d = document.getElementById('test_frame').contentDocument;

        // set values for controls we're not testing
        var presets = [
          { elem: 'node_sti_type',    value: "ClassNode" },
          { elem: 'node_name',        value: "TheNode" },
          { elem: 'node_description', value: "A Description." }
        ];
        // make sure we trigger onchange handlers, so other error checks done
        for (var c=0; c < presets.length; c++){
          var elem = d.getElementById(presets[c].elem);
          elem.focus();
          elem.value = presets[c].value;
          elem.blur();
        }


        var titleSpan = d.getElementById('title_multi_line');
        var titleIcon = d.getElementById('title_error_icon');
        var nodesNewSubmit = d.getElementById('node_submit');
        // alternate between good and bad strings to verify flags on/off
        var testData = [
          { good: false, title: "String with\012two lines." },
          { good: true,  title: "First good title" },
          { good: false, title: "Title with lines\015divided by a CR." },
          { good: true,  title: "Second good title" },
          { good: false, title: "Title broken\015into\012three lines" },
          { good: true,  title: "Third good title" },
          { good: false, title: "Would be a title\015\012if not for the CRLF" },
          { good: true,  title: "Fourth good title" }
        ];

        // make sure all of the other flags in the page stay "off"
        var otherSpans = [ "sti_type_required", "title_required",
                           "title_too_long", "name_required", "name_start_char",
                           "name_nth_char", "name_too_long",
                           "description_recommended", "description_too_long" ];
        var otherIcons = [ "sti_type_error_icon", "name_error_icon",
                           "description_error_icon" ];

        var title = d.getElementById('node_title');
        for (var c=0; c < testData.length; c++){
          title.focus();
          title.value = testData[c].title;
          title.blur();

          if (testData[c].good){
            expect(titleSpan.className).to_not(match, /helpTextFlagged/);
            expect(titleIcon.src).to(match, /blank_error_icon\.png/);
            expect(nodesNewSubmit.className).to(match, /^activeButton$/);
          }
          else {
            expect(titleSpan.className).to(match, /helpTextFlagged/);
            expect(titleIcon.src).to(match, /error_error_icon\.png/);
            expect(nodesNewSubmit.className).to(match, /^inactiveButton$/);
          }

          // make sure there's no spurious reporting of other errors
          for (var cn=0; cn < otherSpans.length; cn++)
            expect(d.getElementById(otherSpans[cn]).className).
              to_not(match, /helpTextFlagged/);
          for (var cn =0; cn < otherIcons.length; cn++)
            expect(d.getElementById(otherIcons[cn]).src).
              to(match, /blank_error_icon\.png/);
        }
      });
    });
  });
});

