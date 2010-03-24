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


var nameAjaxStart = 400;  // to avoid unnecessary server traffic,
                          //   wait after Name change before check




    // define fields subject to check, order they occur in form
var requiredItemElements = [ "sti_type", "title", "name", "description",
  "submit" ];
var itemElementNames = [ "Type selector", "Title field", "Name field",
  "Description box", "Create button" ];
var indexTitle       = 1;
var indexName        = 2;
var indexDescription = 3;
var maxLengths = [ 0, 255, 80, 65535 ];

    // globals w/ defaults, real values figured in plumbEvent...()
var thereIsAClassControl = false;
var thereIsATypeControl = false;
var originalItemName = "";
var controlNamePrefix = "";
var itemSubmit;

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> error condition present
var itemFormErrors = {};


    // after key presses, have to wait for browser to update the input field
    // before we check it (delay in ms)
var dly = 200;


var valueWhenLastChecked = "";
var uniquenessTimerId = -1;
var ajaxRequestInProgress = null;


function plumbEventHandlersToItemCreationElements(customizationSelector){
  for (var c=0; c < requiredItemElements.length-2; c++)
    itemFormErrors["item_" + requiredItemElements[c]] =
      creatingNewItem ? -1 : false;
  for (var c=1; c < requiredItemElements.length-1; c++)
    itemFormErrors["length_" + requiredItemElements[c]] = false;

  if (!creatingNewItem){
    var arrayOfForms = document.getElementsByTagName('form');
    var newItemId;
    for (var c=0; c < arrayOfForms.length; c++){
      newItemId = arrayOfForms[c].id;
      var mtch = newItemId.match(/item/);
      if (mtch != null)
        break;
    }
    controlNamePrefix = newItemId.replace(/^edit_/, "").
                                  replace(/item_?[0-9]*$/, "");
    originalItemName = $(controlNamePrefix + 'item_name').value;
  }


  var testing = $('item_sti_type');
  if (testing != null && testing.type != "hidden")
    thereIsATypeControl = true;
  else
    itemFormErrors['item_sti_type'] = false

  testing = $(controlNamePrefix + 'item_class_item_id')
  thereIsAClassControl = testing != null && testing.type != "hidden";


  itemSubmit = $(controlNamePrefix + 'item_submit');
  if (thereIsATypeControl){
    var ck = $(controlNamePrefix + 'item_sti_type').value;
    if (ck != null && ck != "")
      itemFormErrors['item_sti_type'] = false;
  }


  if (thereIsAClassControl && thereIsATypeControl){
    $(controlNamePrefix + 'item_class_item_id').
      observe('change', classSelectOnchange);
  }


  if (thereIsATypeControl){
    var a = $('item_sti_type');
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
  }

  var b = $(controlNamePrefix + 'item_title');
  var c = $(controlNamePrefix + 'item_name');
  function checkTitle(){
    // this check is unique to Title, do here
    var mtch = b.value.match(/\n|\r/m);
    if (mtch != null && mtch.length > 0){
      $('title_multi_line').className = "helpTextFlagged";
      itemFormErrors['ml_title'] = true;
      $('title_error_icon').src = "/images/error_error_icon.png";
    }
    else {
      $('title_multi_line').className = "";
      itemFormErrors['ml_title'] = false;
    }

    checkFieldRequired(b);
    checkFieldLength(b, indexTitle);
    maybeClearIcon('title');
    if (creatingNewItem){
      var emptyToNotEmpty = generateFromTitle(b, c);
      if (emptyToNotEmpty){
        itemFormErrors["item_name"] = false;
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
    if (creatingNewItem)
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

  function nameFieldValidityCheck(){
    var mtch, val = $(controlNamePrefix + 'item_name').value;

    $('name_start_char').className = "";
    itemFormErrors['char_1_name'] = false;
    if (val.length > 0){
      mtch = val.match(/^[a-zA-Z]/);
      if (mtch == null || mtch.length == 0){
        $('name_start_char').className = "helpTextFlagged";
        itemFormErrors['char_1_name'] = true;
        $('name_error_icon').src = "/images/error_error_icon.png";
      }
    }

    $('name_nth_char').className = "";
    itemFormErrors['char_N_name'] = false;
    if (val.length > 1){
      mtch = c.value.match(/^.[a-zA-Z0-9_-]+$/);
      if (mtch == null || mtch.length == 0){
        $('name_nth_char').className = "helpTextFlagged";
        itemFormErrors['char_N_name'] = true;
        $('name_error_icon').src = "/images/error_error_icon.png";
      }
    }
  }


  var d = $(controlNamePrefix + 'item_description');
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

  if (creatingNewItem)
    makeButtonSeemDisabled(itemSubmit);// items/new -- can't submit a blank form
  else
    makeButtonSeemEnabled(itemSubmit); // items/##/edit -- can submit as-is form

  if (customizationSelector != "submitViaModalbox"){
    itemSubmit.observe('click',
      function(ev){
        if (!okToSubmitItemForm())
          ev.stop();
        else
          if (thereIsATypeControl)
            $('item_sti_type').disabled = false;
      }
    );
  }

  if (thereIsATypeControl)
    a.observe('focus', function(){onfocusCommonBehavior(a);});
  b.observe('focus', function(){onfocusCommonBehavior(b);});
  c.observe('focus', function(){onfocusCommonBehavior(c);});
  d.observe('focus', function(){onfocusCommonBehavior(d);});
  itemSubmit.
    observe('focus', function(){onfocusCommonBehavior(itemSubmit);});
}

function flagItemAsRequired(elemName){
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
    var descReco = itemFormErrors["item_description"];
    itemFormErrors["item_description"] = false;

    var canClear = true;
    for (var err in itemFormErrors){
      mtch = err.match(new RegExp(field));
      if (mtch != null && mtch.length > 0 && itemFormErrors[err]){
        canClear = false;
        break;
      }
    }

    itemFormErrors["item_description"] = descReco;  // restore

    if (canClear){
      if (field == "description" && descReco)
        icon.src = "/images/warn_error_icon.png";
      else
        icon.src = "/images/blank_error_icon.png";
    }
  }


  // if *all* the error flags are clear, then indicate that we can submit
  for (var err in itemFormErrors)
    if (err != "item_description" && itemFormErrors[err] != false){
      makeButtonSeemDisabled(itemSubmit);
      return;
    }
  makeButtonSeemEnabled(itemSubmit);
}


function onfocusCommonBehavior(elem){
  var eId = elem.id;
  var c;
  for (c=0; c   <  requiredItemElements.length &&
            eId != controlNamePrefix + "item_" + requiredItemElements[c];
       c++)
    ;

  if (c >= requiredItemElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  var errFlag = false;
  c = thereIsATypeControl ? 0 : 1;
  for (; c <= lastToCheck; c++){
    var ck = $(controlNamePrefix + "item_" + requiredItemElements[c]);
    if (ck.value == null || ck.value == ""){

      itemFormErrors["item_" + requiredItemElements[c]] = true;
      flagItemAsRequired(requiredItemElements[c]);

      if (c < requiredItemElements.length-2)
        errFlag = true;
    }
    else
      itemFormErrors["item_" + requiredItemElements[c]] = false;
  }

  if (errFlag)
    makeButtonSeemDisabled(itemSubmit);

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
  if (!creatingNewItem)
    idStr = idStr.replace(new RegExp(controlNamePrefix), "");
  var name = idStr.match(/item_(.+)$/)[1];

  if (f.value == null || f.value == ""){
    flagItemAsRequired(name);
    itemFormErrors[idStr] = true;
  }
  else {
    var req = $(name + "_required");
    if ( req != null )
      req.className = "";
    else
      $(name + "_recommended").className = "";

    itemFormErrors[idStr] = false;
  }
}

function checkFieldLength(elem, index){
  var name = elem.id.match(/item_(.+)$/)[1];

  if (elem.value.length > maxLengths[index]){
    $(name + '_too_long').className = "helpTextFlagged";
    itemFormErrors['length_' + name] = true;
    $(name + "_error_icon").src = "/images/error_error_icon.png";
  }
  else {
    $(name + '_too_long').className = "";
    itemFormErrors['length_' + name] = false;
  }
}


function genDialog(){
  var newDialogText = "<p>";
  var accum = false;

  for (var c=0; c < requiredItemElements.length-2; c++){
    if (itemFormErrors["item_" + requiredItemElements[c]] == true){
      accum = true;
      newDialogText += "The " + itemElementNames[c] + " is required. ";
    }
  }
  for (var c=1; c < requiredItemElements.length-1; c++){
    if (itemFormErrors["length_" + requiredItemElements[c]] == true){
      accum = true;
      newDialogText += "The " + itemElementNames[c] + " field must be " +
        maxLengths[c] + " or fewer characters. ";
    }
  }

  if (accum){
    newDialogText += "</p>";
    var titleText = creatingNewItem ?
      "Can't create this item yet" :
      "Can't update this item";
    Modalbox.show(newDialogText,
      { title: titleText,
        slideDownDuration: 0.25, slideUpDuration: 0.1 } );
  }
  return accum;
}



function clearNameUniquenessIndicators(){
    $('name_must_be_unique').className = "";
    $('name_is_unique').className = "confirmationTextInvisible";
    $('name_status_icon').src = '/images/blank_status_icon.png';
}
function nameUCheckSuccess(transport){
  ajaxRequestInProgress = null;
  $('name_must_be_unique').className = "helpTextFlagged";
  $('name_status_icon').src = '/images/error_status_icon.png';
  itemFormErrors["unique_name"] = true;
  makeButtonSeemDisabled(itemSubmit);
}
function nameUCheckFailure(transport){
  ajaxRequestInProgress = null;
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
  var lookup = l.protocol + "//" + l.hostname + ":" + l.port +
    '/w/items/lookup';
  ajaxRequestInProgress = new Ajax.Request(
    lookup, {
      method: 'get', parameters: "name=" + $F(controlNamePrefix + 'item_name'),
      onSuccess: nameUCheckSuccess, onFailure: nameUCheckFailure
    });

  $('name_status_icon').src = '/images/working_status_icon.gif';
}
function maybeCheckNameUniqueness(delay){
  var name = $(controlNamePrefix + 'item_name');

  if (name.value != valueWhenLastChecked){
    valueWhenLastChecked = name.value;

    if (uniquenessTimerId != -1)
      clearTimeout(uniquenessTimerId);
    uniquenessTimerId = -1;
    if (ajaxRequestInProgress != null)
      ajaxRequestInProgress.transport.abort();
    ajaxRequestInProgress = null;

    clearNameUniquenessIndicators();

    var old = itemFormErrors["unique_name"];
    itemFormErrors["unique_name"] = false;
    if (old)
      maybeClearIcon('name');

    var mtch = $('name_error_icon').src.match(/error_error_icon/);
    if (name.value != null && name.value != "" &&
        name.value != originalItemName         &&
        (mtch == null || mtch.length == 0)){
      if (delay > 0)
        uniquenessTimerId = setTimeout(launchNameUniquenessCheck, delay);
      else
        launchNameUniquenessCheck();
    }
  }
}



function getCurrentType(){
  return $('item_sti_type').value;
}



function okToSubmitItemForm(){
  onfocusCommonBehavior(itemSubmit);
  var errors = genDialog();

  if (errors)
    makeButtonSeemDisabled(itemSubmit);
  else
    makeButtonSeemEnabled(itemSubmit);

  return !errors;
}


function classSelectOnchange(){
  var class_ctrl = $(controlNamePrefix + 'item_class_item_id');
  var type_ctrl  = $('item_sti_type');
  var class_val = class_ctrl.value;

  type_ctrl.disabled = false;
  if ( class_val.search( /^[0-9]+$/ ) == -1 )
    return;
  else {
    var new_type = class_to_type['id' + class_val];
    if (typeof new_type == 'undefined')
      return;

    type_ctrl.value = new_type;
    type_ctrl.disabled = true;
  }
}


// function to highlight help text based on Type <select> element state
function typeSelectOnchange(){
  var sel = $('item_sti_type');
  var tags = [ "category_title",   "category_desc",
               "individual_title", "individual_desc",
               "property_title",   "property_desc" ];

  if ($(tags[0]) == null)   // this version of form w/o explanatory text
    return;

  for (var c=0; c != tags.length; c++)
    $(tags[c]).className = "";

  if (sel.value == "CategoryItem"){
    $(tags[0]).className = "titleSelectedItemDescription";
    $(tags[1]).className = "bodySelectedItemDescription";
  }
  else if (sel.value == "IndividualItem"){
    $(tags[2]).className = "titleSelectedItemDescription";
    $(tags[3]).className = "bodySelectedItemDescription";
  }
  else if (sel.value == "PropertyItem"){
    $(tags[4]).className = "titleSelectedItemDescription";
    $(tags[5]).className = "bodySelectedItemDescription";
  }
}
