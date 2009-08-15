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
  var submitId = "node_submit";
  var flagTextIds = [ "sti_type_required", "title_required", "name_required",
                      "description_recommended" ];
  var flagIconIds = [ "sti_type_error_icon", "title_error_icon",
                      "name_error_icon", "description_error_icon" ];
  var flagIconSrc = [ "error_error_icon", "error_error_icon",
                      "error_error_icon", "warn_error_icon" ];
  var inputIds    = [ "node_sti_type", "node_title", "node_name",
                      "node_description", submitId ];

  describe( "Dynamic required input field checks in nodes/new page", function(){
    describe( "Check results with no user input", function(){
      it( "Shows 'Create' button inactive when blank page first loaded",
          function(){
        var d = document.getElementById('test_frame').contentDocument;
        expect(d.getElementById('node_submit').className).
          to(match, /inactiveButton/);
      });

      it( "Doesn't display flags when blank page first loaded", function(){
        var d = document.getElementById('test_frame').contentDocument;

        for (var c=0; c < flagTextIds.length; c++){
          expect(d.getElementById(flagTextIds[c]).className).
            to_not(match, /helpTextFlagged/);
          expect(d.getElementById(flagIconIds[c]).src).to(match,
            /blank_error_icon\.png/);
        }
      });

      it( "Flags blank inputs when input focus passes them", function(){
        var d = document.getElementById('test_frame').contentDocument;

        for (var c=1; c < inputIds.length; c++){
          d.getElementById(inputIds[c]).focus();

          var cn;
          for (cn=0; cn < c; cn++){
            expect(d.getElementById(flagTextIds[cn]).className).
              to(match, /helpTextFlagged/);
            expect(d.getElementById(flagIconIds[cn]).src).to(match,
              new RegExp(flagIconSrc[cn] + "\\.png"));
          }
          for (;cn < flagTextIds.length; cn++){
            expect(d.getElementById(flagTextIds[cn]).className).
              to_not(match, /helpTextFlagged/);
            expect(d.getElementById(flagIconIds[cn]).src).to(match,
              /blank_error_icon\.png/);
          }
        }
      });

      it( "Clears input-required flags on input", function(){
        var tf = document.getElementById('test_frame');
        var d = tf.contentDocument;

        // first set inputs from bottom, then start over from top
        var letters = [ "ClassNode", "G", "K", "q" ];
        var innerLoopStart = [ inputIds.length-2, 0 ];
        var innerLoopEnd   = [ -1,                inputIds.length-1 ];
        var innerLoopDelta = [ -1,                1 ];
        for (var c=0; c < 2; c++){

          d.getElementById(submitId).focus();     // all inputs flagged

          for (var cn=innerLoopStart[c];
               cn != innerLoopEnd[c];
               cn += innerLoopDelta[c]){

            var elem = d.getElementById(inputIds[cn]);
            elem.focus();
            elem.value = letters[cn];
            elem.blur();

            var ct;
            for (ct = innerLoopStart[c];
                 ct != cn + innerLoopDelta[c];
                 ct += innerLoopDelta[c]){
              expect(d.getElementById(flagTextIds[ct]).className).
                to_not(match, /helpTextFlagged/);
              expect(d.getElementById(flagIconIds[ct]).src).to(match,
                /blank_error_icon\.png/);
            }
            for (;ct != innerLoopEnd[c];
                 ct += innerLoopDelta[c]){
              expect(d.getElementById(flagTextIds[ct]).className).
                to(match, /helpTextFlagged/);
              expect(d.getElementById(flagIconIds[ct]).src).to(match,
                new RegExp(flagIconSrc[ct] + "\\.png"));
            }
          }

          // and check that "Create" button is now enabled
          expect(d.getElementById('node_submit').className).
            to(match, /^activeButton/);

          // setup for next pass
          var src = tf.src;
          tf.src = src;
          letters = [ "PropertyNode", "p", "t", "Z" ];
        }
      });

/*
      it( "Sets input-required flags when input changed to blank", function(){

      });
*/
    });
  });
});

