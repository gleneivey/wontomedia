// WontoMedia - a wontology web application
// Copyright (C) 2011 - Glen E. Ivey
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


var selectElems      = [ "subject", "predicate", "obj" ];

    // define fields subject to check, order they occur in form
  // these arrays must have same index order:
var requiredConnectionElements =
  [ "subject", "predicate", "kind_of_obj", "obj", "submit" ];
var connectionElementNames =
  [ "Subject selector", "Relationship selector",
    "Object kind", "Object content" ];
var controlIds =
  [ [ "connection_subject_id" ],
    [ "connection_predicate_id" ],
    [ "connection_kind_of_obj_scalar", "connection_kind_of_obj_item" ],
    [ "connection_scalar_obj", "connection_obj_id" ],
    [ "connection_submit" ]  // this one doesn't really matter--won't be used
  ];
var controlTypes =
  [ [ "value" ],
    [ "value" ],
    [ "checked", "checked" ],
    [ "value", "value" ],
    [ "checked" ]            // this one doesn't really matter--won't be used
  ];

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> error condition present
var connectionFormErrors = {};     // don't display errors until user goes past

var lastValue = {}                 // don't error check unless changed
var connectionSubmit;              // $(submit-botton) for convenience



if ((typeof inAConnectionsForm !== 'undefined') && inAConnectionsForm){
  connectionSubmit = $('connection_submit');

  lastValue = {
    subject   : $('connection_subject_id').value,
    predicate : $('connection_predicate_id').value,
    obj       : $('connection_obj_id').value,
    scalar    : $('connection_scalar_obj').value
  };

  for (var c=0; c < requiredConnectionElements.length-1; c++)
    connectionFormErrors[requiredConnectionElements[c]] =
      creatingNewConnection ? -1 : false;

  for (var c=0; c < selectElems.length; c++){
    createIdOnchangeHandler(selectElems[c]);
    createIdOnfocusHandler(selectElems[c]);
  }
  createKindHandlers();
  createScalarHandlers();

  if (creatingNewConnection)
        // connections/new -- can't submit a blank form
    makeButtonSeemDisabled(connectionSubmit);
  else  // connections/##/edit -- can submit as-is form
    makeButtonSeemEnabled(connectionSubmit);
  connectionSubmit.observe('click', submitOnclickHandler);
  connectionSubmit.observe('focus',
    function(){ onfocusBehavior(connectionSubmit); } );

  // do after browser has done final layout of all the select controls
  setDescDivsWidths([ 'subject', 'predicate', 'obj' ]);
  syncEnabledStateOfObjectControls();
}


function createIdOnchangeHandler(thisName){
  var thisElem = $('connection_' + thisName + '_id');
  if (thisElem == null)  // only deal with ID select controls
    return;
  thisElem.observe('change',
    function(){                       // nest all these fn defs for closure
      if (thisElem.value != lastValue[thisName]){
        var lastLast = lastValue[thisName];
        lastValue[thisName] = thisElem.value;

        if (thisElem.value == ""){
          divToBlank(thisName);
          flagConnectionAsRequired(thisName);
        }
        else if (thisElem.value == "-1"){
          divToBlank(thisName);
          var popupType = (thisName == "predicate") ? "verb" : "noun";
          itemCreatePopup(thisElem, lastLast, popupType, null);
        }
        else {
          clearError(thisName);
          loadItemDescDiv(thisName, thisElem);
        }
        refreshSubmitState();
      }
    }
  );
}

function loadItemDescDiv(thisName, thisElem){
  divToWorking(thisName);

  var winloc = window.location;
  var base = winloc.protocol + "//" + winloc.hostname + ":" + winloc.port;
  new Ajax.Request(base + "/w/items/" + thisElem.value + ".json", {
    method: 'get',
    onSuccess: function(response){
      var itemObject = response.responseJSON;
      var key = getFirstHashKey(itemObject);
      divToText(thisName, itemObject[key]["description"]);
    },
    onFailure: function(){
      divToBlank(thisName);
    }
  });
}

function createScalarHandlers(){
  var name = 'scalar';
  var scalar = $("connection_scalar_obj");

  scalar.observe('change',
    function(){                       // nest all these fn defs for closure
      if (scalar.value != lastValue[name]){
        var lastLast = lastValue[name];
        lastValue[name] = scalar.value;

        if (scalar.value == "")       // pretend we're same as 'obj_id' select
          flagConnectionAsRequired('obj');
        else
          clearError('obj');
        refreshSubmitState();
      }
    }
  );
}

function getFirstHashKey(hashObj){
  for (var key in hashObj)
    return key;
}

function divToBlank(name){
  divToImg(name, "blank");
}

function divToWorking(name){
  divToImg(name, "working");
}

function divToImg(divName, imageName){
  $(divName + '_desc').className = "desc";
  $(divName + '_desc').innerHTML =
    "<img alt='' width='32' height='16' id='" + divName + "_status_icon' " +
    "     src='/images/" + imageName + "_status_icon.png' />";
}

function divToText(divName, divText){
  if (divText === undefined || divText == null)
    divText = "";
  $(divName + '_desc').className = "";
  $(divName + '_desc').innerHTML = "<p>" + divText.escapeHTML() + "</p>";
}


function createIdOnfocusHandler(thisName){
  var thisElem = $('connection_' + thisName + '_id');
  if (thisElem == null)
    return;
  thisElem.observe('focus', function(){ onfocusBehavior(thisElem); } );
}

function createKindHandlers(){
  thisElem = $('connection_kind_of_obj_scalar');
  thisElem.observe('focus', function(){ onfocusBehavior(thisElem); } );
  thisElem.observe('change', kindOnchangeBehavior);

  thisElem = $('connection_kind_of_obj_item');
  thisElem.observe('focus', function(){ onfocusBehavior(thisElem); } );
  thisElem.observe('change', kindOnchangeBehavior);
}

function kindOnchangeBehavior(){
  syncEnabledStateOfObjectControls();

  var itemChecked   = $('connection_kind_of_obj_item'  ).checked;
  var scalarChecked = $('connection_kind_of_obj_scalar').checked;

  var hasAValue = itemChecked || scalarChecked;
  if (hasAValue)
    clearError('kind_of_obj');
  else
    flagConnectionAsRequired('kind_of_obj');

  if (connectionFormErrors['obj'] != -1){
    var value = null;
    if (itemChecked)
       value = $('connection_obj_id').value;
    else
       value = $('connection_scalar_obj').value;
    if (value != null && value != "")
      clearError('obj');               // if selected control has a value, great
    else
      flagConnectionAsRequired('obj'); // otherwise, error (ignore other ctrl)
  }

  refreshSubmitState();
}

function onfocusBehavior(elem){
  // find this control's position in flag arrays.  Value of rCE[c] is
  // always a substring of matching control's id=''
  var c;
  for (c=0; c < requiredConnectionElements.length; c++){
    var re = new RegExp(requiredConnectionElements[c]);
    var mtch = elem.id.match(re);
    if (mtch != null && mtch.length > 0)
      break;
  }

  if (c >= requiredConnectionElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  for (c=0; c <= lastToCheck; c++){
    var hasAValue = false;
    var equivalentIds = controlIds[c];

     perControlLoop:
    for (var cn=0; cn < equivalentIds.length; cn++){

      control = $(equivalentIds[cn]);
      if (control.disabled)
        continue perControlLoop;

      if (controlTypes[c][cn] == "checked"){
        if (control.checked == true){
          hasAValue = true;
          break;
        }
      }
      else { // Type == "value"
        if (control.value != null && control.value != ""){
          hasAValue = true;
          break;
        }
      }
    }

    if (hasAValue)
      clearError(requiredConnectionElements[c]);
    else
      flagConnectionAsRequired(requiredConnectionElements[c]);
  }
  refreshSubmitState();
}

function flagConnectionAsRequired(elemName){
  connectionFormErrors[elemName] = true;
  maybeSetTextClass(elemName, "helpTextFlagged");
  $(elemName + "_error_icon").src = "/images/error_error_icon.png";
}

function clearError(elemName){
  connectionFormErrors[elemName] = false;
  maybeSetTextClass(elemName, "");
  $(elemName + "_error_icon").src = "/images/blank_error_icon.png";
}

function maybeSetTextClass(elemName, newClass){
  var requiredText = $(elemName + "_required");
  if (requiredText)
    requiredText.className = newClass
}

function refreshSubmitState(){
  var detectedAtLeastOneError = false;
  for (var c =0; c < requiredConnectionElements.length-1; c++)
    if (connectionFormErrors[requiredConnectionElements[c]] != false)
      detectedAtLeastOneError = true;

  if (detectedAtLeastOneError)
    makeButtonSeemDisabled(connectionSubmit);
  else
    makeButtonSeemEnabled(connectionSubmit);
}


function submitOnclickHandler(ev){
  onfocusBehavior(connectionSubmit);
  var dialogDisplayed = maybeShowErrorDialog();
  if (dialogDisplayed)
    ev.stop();
}

function maybeShowErrorDialog(){
  var newDialogText = "<p>";

  var accum = false;
  for (var c=0; c < requiredConnectionElements.length-1; c++){
    if (connectionFormErrors[requiredConnectionElements[c]] == true){
      accum = true;
      newDialogText += "The " + connectionElementNames[c] +
        " must have a value. ";
    }
  }

  if (accum){
    newDialogText += "</p>";
    var titleText =
      creatingNewConnection ? "Can't create this connection yet" :
        "Can't update this connection";
    Modalbox.show(newDialogText, { title: titleText,
                                   slideDownDuration: 0.25,
                                   slideUpDuration: 0.1 } );
  }
  return accum;
}

function syncEnabledStateOfObjectControls(){
  var scalarDisabled = !($('connection_kind_of_obj_scalar').checked);
  $('connection_scalar_obj').disabled = scalarDisabled;
  if (!scalarDisabled){
    divToBlank('obj');
    lastValue['obj'] = "";
  }

  var idDisabled = !($('connection_kind_of_obj_item')).checked;
  control = $('connection_obj_id');
  control.disabled = idDisabled;
  if (!idDisabled && (control.value != lastValue['obj']) )
    loadItemDescDiv('obj', control);
}

function setDescDivsWidths(names){
  for (var c=0; c < names.length; c++){
    var descDiv = $(names[c] + "_desc");
    var w = $("connection_" + names[c] + "_id").getWidth();
    descDiv.style.width  = w + "px";
  }
}
