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


// package of code to implement required-inputs-can't-be-empty checks
//   (for nodes/new page)

    // define fields subject to check, order they occur in form
var requiredInputElements = [ "sti_type", "title", "name",
                              "description", "submit" ];
var inputElementNames = [ "Type selector", "Title field", "Name field",
                          "Description box", "Create button" ];

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> required field not filled
var inputRequiredErrors = {};
for (var c=0; c < requiredInputElements.length-2; c++)
  inputRequiredErrors[requiredInputElements[c]];

    // validation function
function checkRequiredFields(e){
  var anyErrors = false;
  var eId = e.id;
  var c;
  for (c=0; c   <  requiredInputElements.length &&
            eId != "node_" + requiredInputElements[c];    c++)
    ;

  if (c >= requiredInputElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  for (c=0; c <= lastToCheck; c++){
    ck = $("node_" + requiredInputElements[c]);
    if (ck.value === undefined || ck.value == null || ck.value == ""){

      inputRequiredErrors[requiredInputElements[c]] = true;
      anyErrors = true;

      var req = $(requiredInputElements[c] + "_required");
      if ( req != null ){
        req.className = "helpTextFlagged";
        $(requiredInputElements[c] + "_error_icon").src =
          "/images/error_error_icon.png";
      }
      else {
        $(requiredInputElements[c] + "_recommended").className =
          "helpTextFlagged";
        $(requiredInputElements[c] + "_error_icon").src =
          "/images/warn_error_icon.png";
      }
    }
    else {
      inputRequiredErrors[requiredInputElements[c]] = false;
    }
  }

  if (anyErrors)
    makeButtonSeemDisabled($('node_submit'));
}


function genDialog(){
  var newDialogText = "<p>";
  var accum = false;

  for (var c=0; c < requiredInputElements.length-2; c++){
    if (inputRequiredErrors[requiredInputElements[c]]){
      accum = true;
      newDialogText += "The " + inputElementNames[c] + " is required. ";
    }
  }

  if (accum){
    newDialogText += "</p>";
    Modalbox.show(newDialogText,
      { title: "Can't create this node yet",
        slideDownDuration: 0.25, slideUpDuration: 0.1 } );
  }
  return accum;
}


function makeButtonSeemEnabled(button){
  button.className = "activeButton";
}
function makeButtonSeemDisabled(button){
  button.className = "inactiveButton";
}


    // plumb validation function to relevant elements
var a = $('node_sti_type');    a.onfocus= function(){checkRequiredFields(a);};
var b = $('node_title');       b.onfocus= function(){checkRequiredFields(b);};
var c = $('node_name');        c.onfocus= function(){checkRequiredFields(c);};
var d = $('node_description'); d.onfocus= function(){checkRequiredFields(d);};

var e = $('node_submit');      e.onfocus= function(){checkRequiredFields(e);};
makeButtonSeemDisabled(e);
e.onclick = function(){
  checkRequiredFields(e);
  var errors = genDialog();

  if (errors)
    makeButtonSeemDisabled(e);
  else
    makeButtonSeemEnabled(e);
  return !errors;
}


