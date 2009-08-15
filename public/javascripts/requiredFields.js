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



// function to highlight help text based on Type <select> element state
function typeSelectOnchange(){
  var sel = $('node_sti_type');
  var tags = [ "category_title", "category_desc",
               "item_title",     "item_desc",
               "property_title", "property_desc" ];

  for (var c=0; c != tags.length; c++)
    $(tags[c]).className = "";

  if (sel.value == "ClassNode"){
    $("category_title").className = "titleSelectedItemDescription";
    $("category_desc").className = "bodySelectedItemDescription";
  }
  else if (sel.value == "ItemNode"){
    $("item_title").className = "titleSelectedItemDescription";
    $("item_desc").className = "bodySelectedItemDescription";
  }
  else if (sel.value == "PropertyNode"){
    $("property_title").className = "titleSelectedItemDescription";
    $("property_desc").className = "bodySelectedItemDescription";
  }
}




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
  inputRequiredErrors["node_" + requiredInputElements[c]] = -1;


function flagAsRequired(elemName){
  var req = $(elemName + "_required");
  if ( req != null ){
    req.className = "helpTextFlagged";
    $(elemName + "_error_icon").src = "/images/error_error_icon.png";
  }
  else {
    $(elemName + "_recommended").className = "helpTextFlagged";
    $(elemName + "_error_icon").src = "/images/warn_error_icon.png";
  }
}

function clearFlag(elemName){
  var req = $(elemName + "_required");
  if ( req != null )
    req.className = "";
  else
    $(elemName + "_recommended").className = "";
  $(elemName + "_error_icon").src = "/images/blank_error_icon.png";
}


    // validation function
function checkRequiredFields(e){
  var errFlag = false;
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
    if (ck.value == null || ck.value == ""){

      inputRequiredErrors["node_" + requiredInputElements[c]] = true;
      flagAsRequired(requiredInputElements[c]);

      if (c < requiredInputElements.length-2)
        errFlag = true;
    }
    else {
      inputRequiredErrors["node_" + requiredInputElements[c]] = false;
    }
  }

  if (errFlag)
    makeButtonSeemDisabled($('node_submit'));
}

function anyErrors(){
  for (var c=0; c < requiredInputElements.length-2; c++)
    if (inputRequiredErrors["node_" + requiredInputElements[c]])
      return true;
  return false;
}

function checkAField(f){
  var idStr = f.id;
  var idAry = idStr.match(/^node_(.+)$/);
  var name = idAry[1];

  if (f.value == null || f.value == ""){
    flagAsRequired(name);
    inputRequiredErrors[f.id] = true;
    if (anyErrors())
      makeButtonSeemDisabled($('node_submit'));
  }
  else {
    clearFlag(name);
    var oldErr = inputRequiredErrors[f.id];
    inputRequiredErrors[f.id] = false;
    if (oldErr && !anyErrors())
      makeButtonSeemEnabled($('node_submit'));
  }
}


function genDialog(){
  var newDialogText = "<p>";
  var accum = false;

  for (var c=0; c < requiredInputElements.length-2; c++){
    if (inputRequiredErrors["node_" + requiredInputElements[c]]){
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
var a = $('node_sti_type');
a.onfocus=  function(){checkRequiredFields(a);};
a.onkeypress= function(){setTimeout(checkAField, 50, a);};
a.onchange= function(){
  typeSelectOnchange();
  checkAField(a);
};

var b = $('node_title');
b.onfocus= function(){checkRequiredFields(b);};
b.onchange= function(){checkAField(b);};
b.onkeypress= function(){setTimeout(checkAField, 50, b);};
var c = $('node_name');
c.onfocus= function(){checkRequiredFields(c);};
c.onchange= function(){checkAField(c);};
c.onkeypress= function(){setTimeout(checkAField, 50, c);};
var d = $('node_description');
d.onfocus= function(){checkRequiredFields(d);};
d.onchange= function(){checkAField(d);};
d.onkeypress= function(){setTimeout(checkAField, 50, d);};

var e = $('node_submit');
e.onfocus= function(){checkRequiredFields(e);};
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


