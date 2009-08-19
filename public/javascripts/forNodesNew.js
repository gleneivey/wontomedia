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
var indexTitle       = 1;
var indexName        = 2;
var indexDescription = 3;
var maxLengths = [ 0, 255, 80, 65535 ];

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> error condition present
var inputErrors = {};
for (var c=0; c < requiredInputElements.length-2; c++)
  inputErrors["node_" + requiredInputElements[c]] = -1;
for (var c=1; c < requiredInputElements.length-1; c++)
  inputErrors["length_" + requiredInputElements[c]] = false;

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
}

function maybeClearIcon(field){
  icon = $(field + "_error_icon");
  var mtch = icon.src.match(/blank_/);
  if (mtch == null || mtch.length == 0){

    // "recommended" is a special case....
    var descReco = inputErrors["node_description"];
    inputErrors["node_description"] = false;

    var canClear = true;
    for (var err in inputErrors){
      mtch = err.match(new RegExp(field));
      if (mtch != null && mtch.length > 0 && inputErrors[err]){
        inputErrors["node_description"] = descReco;  // restore
        canClear = false;
        break;
      }
    }

    if (canClear){
      if (field == "description" && descReco){
        inputErrors["node_description"] = true;
        icon.src = "/images/warn_error_icon.png";
      }
      else
        icon.src = "/images/blank_error_icon.png";
    }
  }


  for (var err in inputErrors)
    if (err != "node_description" && inputErrors[err] != false){
      makeButtonSeemDisabled($('node_submit'));
      return;
    }
  makeButtonSeemEnabled($('node_submit'));
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

      inputErrors["node_" + requiredInputElements[c]] = true;
      flagAsRequired(requiredInputElements[c]);

      if (c < requiredInputElements.length-2)
        errFlag = true;
    }
    else {
      inputErrors["node_" + requiredInputElements[c]] = false;
    }
  }

  if (errFlag)
    makeButtonSeemDisabled($('node_submit'));
}

function checkFieldRequired(f){
  var idStr = f.id;
  var idAry = idStr.match(/^node_(.+)$/);
  var name = idAry[1];

  if (f.value == null || f.value == ""){
    flagAsRequired(name);
    inputErrors[f.id] = true;
  }
  else {
    clearFlag(name);
    var oldErr = inputErrors[f.id];
    inputErrors[f.id] = false;
  }
}

function checkFieldLength(elem, name, index){
  if (elem.value.length > maxLengths[index]){
    $(name + '_too_long').className = "helpTextFlagged";
    inputErrors['length_' + name] = true;
    $(name + "_error_icon").src = "/images/error_error_icon.png";
  }
  else {
    $(name + '_too_long').className = "";
    inputErrors['length_' + name] = false;
  }
}


function genDialog(){
  var newDialogText = "<p>";
  var accum = false;

  for (var c=0; c < requiredInputElements.length-2; c++){
    if (inputErrors["node_" + requiredInputElements[c]] == true){
      accum = true;
      newDialogText += "The " + inputElementNames[c] + " is required. ";
    }
  }
  for (var c=1; c < requiredInputElements.length-1; c++){
    if (inputErrors["length_" + requiredInputElements[c]] == true){
      accum = true;
      newDialogText += "The " + inputElementNames[c] + " field must be " +
        maxLengths[c] + " or fewer characters. ";
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


  // after keypress events, have to wait for browser to update the input field
  // before we check it (delay in ms)
var dly = 200;

    // plumb validation function to relevant elements
var a = $('node_sti_type');
a.onfocus=  function(){checkRequiredFields(a);};
function checkType(){
  checkFieldRequired(a);
  maybeClearIcon('sti_type');
}
a.onkeypress= function(){setTimeout(checkType, dly);};
a.onchange= function(){
  typeSelectOnchange();
  checkFieldRequired(a);
  maybeClearIcon('sti_type');
};

var b = $('node_title');
b.onfocus= function(){checkRequiredFields(b);};
function checkTitle(){
  checkFieldRequired(b);
  checkFieldLength(b, "title", indexTitle);
  maybeClearIcon('title');
}
b.onchange= function(){checkTitle();};
b.onkeypress= function(){setTimeout(checkTitle, dly);};

var c = $('node_name');
c.onfocus= function(){checkRequiredFields(c);};
function checkName(){
  checkFieldRequired(c);
  checkFieldLength(c, "name", indexName);
  maybeClearIcon('name');
}
c.onchange= function(){checkName();};
c.onkeypress= function(){setTimeout(checkName, dly);};

var d = $('node_description');
d.onfocus= function(){checkRequiredFields(d);};
function checkDescription(){
  checkFieldRequired(d);
  checkFieldLength(d, "description", indexDescription);
  maybeClearIcon('description');
}
d.onchange= function(){checkDescription();};
d.onkeypress= function(){setTimeout(checkDescription, dly);};

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

