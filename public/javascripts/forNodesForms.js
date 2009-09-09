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


var test = $('node_sti_type');
var thereIsATypeControl = (test != null);

var controlNamePrefix = "";
var originalNodeName = ""
if (!thereIsATypeControl){
  controlNamePrefix = document.forms[0].className.
                        replace(/^edit_/, "").
                        replace(/node$/, "");

  originalNodeName = $(controlNamePrefix + 'node_name').value;
}

var submit = $(controlNamePrefix + 'node_submit');
var nameAjaxStart = 400;  // to avoid unnecessary server traffic,
                          //   wait after Name change before check



// function to highlight help text based on Type <select> element state
function typeSelectOnchange(){
  var sel = $('node_sti_type');
  var tags = [ "category_title", "category_desc",
               "item_title",     "item_desc",
               "property_title", "property_desc" ];

  for (var c=0; c != tags.length; c++)
    $(tags[c]).className = "";

  if (sel.value == "ClassNode"){
    $(tags[0]).className = "titleSelectedItemDescription";
    $(tags[1]).className = "bodySelectedItemDescription";
  }
  else if (sel.value == "ItemNode"){
    $(tags[2]).className = "titleSelectedItemDescription";
    $(tags[3]).className = "bodySelectedItemDescription";
  }
  else if (sel.value == "PropertyNode"){
    $(tags[4]).className = "titleSelectedItemDescription";
    $(tags[5]).className = "bodySelectedItemDescription";
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
  inputErrors["node_" + requiredInputElements[c]] =
    thereIsATypeControl ? -1 : false;
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

function maybeClearIcon(field){
  icon = $(field + "_error_icon");
  var mtch = icon.src.match(/blank_/);

  // if icon already clear, then don't need to actually clear
  if (mtch == null || mtch.length == 0){

    // "recommended" is a special case....
    var descReco = inputErrors["node_description"];
    inputErrors["node_description"] = false;

    var canClear = true;
    for (var err in inputErrors){
      mtch = err.match(new RegExp(field));
      if (mtch != null && mtch.length > 0 && inputErrors[err]){
        canClear = false;
        break;
      }
    }

    inputErrors["node_description"] = descReco;  // restore

    if (canClear){
      if (field == "description" && descReco)
        icon.src = "/images/warn_error_icon.png";
      else
        icon.src = "/images/blank_error_icon.png";
    }
  }


  // if *all* the error flags are clear, then indicate that we can submit
  for (var err in inputErrors)
    if (err != "node_description" && inputErrors[err] != false){
      makeButtonSeemDisabled(submit);
      return;
    }
  makeButtonSeemEnabled(submit);
}


    // validation functions
function nameFieldValidityCheck(){
  var mtch, val = $(controlNamePrefix + 'node_name').value;

  $('name_start_char').className = "";
  inputErrors['char_1_name'] = false;
  if (val.length > 0){
    mtch = val.match(/^[a-zA-Z]/);
    if (mtch == null || mtch.length == 0){
      $('name_start_char').className = "helpTextFlagged";
      inputErrors['char_1_name'] = true;
      $('name_error_icon').src = "/images/error_error_icon.png";
    }
  }

  $('name_nth_char').className = "";
  inputErrors['char_N_name'] = false;
  if (val.length > 1){
    mtch = c.value.match(/^.[a-zA-Z0-9_-]+$/);
    if (mtch == null || mtch.length == 0){
      $('name_nth_char').className = "helpTextFlagged";
      inputErrors['char_N_name'] = true;
      $('name_error_icon').src = "/images/error_error_icon.png";
    }
  }
}


function onfocusCommonBehavior(elem){
  var eId = elem.id;
  var c;
  for (c=0; c   <  requiredInputElements.length &&
            eId != controlNamePrefix + "node_" + requiredInputElements[c];
       c++)
    ;

  if (c >= requiredInputElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  var errFlag = false;
  c = thereIsATypeControl ? 0 : 1;
  for (; c <= lastToCheck; c++){
    ck = $(controlNamePrefix + "node_" + requiredInputElements[c]);
    if (ck.value == null || ck.value == ""){

      inputErrors["node_" + requiredInputElements[c]] = true;
      flagAsRequired(requiredInputElements[c]);

      if (c < requiredInputElements.length-2)
        errFlag = true;
    }
    else
      inputErrors["node_" + requiredInputElements[c]] = false;
  }

  if (errFlag)
    makeButtonSeemDisabled(submit);

  // refresh everything
  if (thereIsATypeControl)
    maybeClearIcon('sti_type');
  maybeClearIcon('title');
  maybeClearIcon('name');
  maybeClearIcon('description');
  maybeCheckNameUniqueness(nameAjaxStart);
}

function checkFieldRequired(f){
  var idStr = f.id;
  if (!thereIsATypeControl)
    idStr = idStr.replace(new RegExp(controlNamePrefix), "");
  var name = idStr.match(/node_(.+)$/)[1];

  if (f.value == null || f.value == ""){
    flagAsRequired(name);
    inputErrors[idStr] = true;
  }
  else {
    var req = $(name + "_required");
    if ( req != null )
      req.className = "";
    else
      $(name + "_recommended").className = "";

    inputErrors[idStr] = false;
  }
}

function checkFieldLength(elem, index){
  var name = elem.id.match(/node_(.+)$/)[1];

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
    var titleText = thereIsATypeControl ?
      "Can't create this node yet" :
      "Can't update this node";
    Modalbox.show(newDialogText,
      { title: titleText,
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




var valueWhenLastChecked = "";
var uniquenessTimerId = -1;
function nameUCheckSuccess(transport){
  $('name_must_be_unique').className = "helpTextFlagged";
  $('name_status_icon').src = '/images/error_status_icon.png';
  inputErrors["unique_name"] = true;
  makeButtonSeemDisabled(submit);
}
function nameUCheckFailure(transport){
  if (transport.status == 404){
    $('name_is_unique').className = "confirmationTextShow";
    $('name_status_icon').src = '/images/good_status_icon.png';
  }
  else
    $('name_status_icon').src = '/images/blank_status_icon.png';
}
function launchNameUniquenessCheck(){
  // we only have one timer ever, and this call shows it just expired, so...
  uniquenessTimerId = -1;

  var l = window.location;
  var lookup = l.protocol + "//" + l.hostname + ":" + l.port + '/nodes/lookup';
  new Ajax.Request(lookup, {
                    method: 'get', parameters: "name=" +
                      $F(controlNamePrefix + 'node_name'),
                    onSuccess: nameUCheckSuccess, onFailure: nameUCheckFailure
                  });

  $('name_status_icon').src = '/images/working_status_icon.png';
}
function maybeCheckNameUniqueness(delay){
  var name = $(controlNamePrefix + 'node_name');

  if (name.value != valueWhenLastChecked){
    valueWhenLastChecked = name.value;

    if (uniquenessTimerId != -1)
      clearTimeout(uniquenessTimerId);
    uniquenessTimerId = -1;

    $('name_must_be_unique').className = "";
    $('name_is_unique').className = "confirmationTextInvisible";
    $('name_status_icon').src = '/images/blank_status_icon.png';

    var old = inputErrors["unique_name"];
    inputErrors["unique_name"] = false;
    if (old)
      maybeClearIcon('name');

    var mtch = $('name_error_icon').src.match(/error_error_icon/);
    if (name.value != null && name.value != "" &&
        name.value != originalNodeName         &&
        (mtch == null || mtch.length == 0)){
      if (delay > 0)
        uniquenessTimerId = setTimeout(launchNameUniquenessCheck, delay);
      else
        launchNameUniquenessCheck();
    }
  }
}




  // after key presses, have to wait for browser to update the input field
  // before we check it (delay in ms)
var dly = 200;

    // plumb validation function to relevant elements
if (thereIsATypeControl){
  var a = $('node_sti_type');
  a.observe('keyup',
    function(ev){
      if (ev.keyCode != Event.KEY_TAB){   // onfocus does all we need for this
        setTimeout(
          function(){
            checkFieldRequired(a);
            maybeClearIcon('sti_type');
          } ,
          dly
        );
      }
    }
  );

  a.observe('change',
    function(){
      typeSelectOnchange();
      checkFieldRequired(a);
      maybeClearIcon('sti_type');
    }
  );

  function getCurrentType(){
    return $('node_sti_type').value;
  }
}

var b = $(controlNamePrefix + 'node_title');
var c = $(controlNamePrefix + 'node_name');
function checkTitle(){
  // this check is unique to Title, do here
  var mtch = b.value.match(/\n|\r/m);
  if (mtch != null && mtch.length > 0){
    $('title_multi_line').className = "helpTextFlagged";
    inputErrors['ml_title'] = true;
    $('title_error_icon').src = "/images/error_error_icon.png";
  }
  else {
    $('title_multi_line').className = "";
    inputErrors['ml_title'] = false;
  }

  checkFieldRequired(b);
  checkFieldLength(b, indexTitle);
  maybeClearIcon('title');
  if (thereIsATypeControl){
    var emptyToNotEmpty = generateFromTitle(b, c);
    if (emptyToNotEmpty){
      inputErrors["node_name"] = false;
      $('name_required').className = "";
      maybeClearIcon('name');
    }
  }
  nameFieldValidityCheck();
}

b.observe('change', function(){checkTitle();});
b.observe('keyup',
  function(ev){
    if (ev.keyCode != Event.KEY_TAB)
      setTimeout(checkTitle, dly);
  }
);

function checkName(){
  nameFieldValidityCheck();
  checkFieldRequired(c);
  checkFieldLength(c, indexName);
  maybeClearIcon('name');
  if (thereIsATypeControl)
    generateToName(b, c);


  // do last, because we're going to skip part of this if other errors...
  maybeCheckNameUniqueness(nameAjaxStart);
}
c.observe('change', function(){checkName();});
c.observe('keyup',
  function(ev){
    if (ev.keyCode != Event.KEY_TAB)
      setTimeout(checkName, dly);
  }
);

var d = $(controlNamePrefix + 'node_description');
function checkDescription(){
  checkFieldRequired(d);
  checkFieldLength(d, indexDescription);
  maybeClearIcon('description');
}
d.observe('change', function(){checkDescription();});
d.observe('keyup',
  function(ev){
    if (ev.keyCode != Event.KEY_TAB)
      setTimeout(checkDescription, dly);
  }
);


var e = submit;
if (thereIsATypeControl)
  makeButtonSeemDisabled(e);       // nodes/new -- can't submit a blank form
else
  makeButtonSeemEnabled(e);        // nodes/##/edit -- can submit as-is form

e.observe('click',
  function(ev){
    onfocusCommonBehavior(e);
    var errors = genDialog();

    if (errors){
      ev.stop();
      makeButtonSeemDisabled(e);
    }
    else
      makeButtonSeemEnabled(e);
  }
);


if (thereIsATypeControl)
  a.observe('focus', function(){onfocusCommonBehavior(a);});
b.observe('focus', function(){onfocusCommonBehavior(b);});
c.observe('focus', function(){onfocusCommonBehavior(c);});
d.observe('focus', function(){onfocusCommonBehavior(d);});
e.observe('focus', function(){onfocusCommonBehavior(e);});