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


var selectElems = [ "subject", "predicate", "obj", "submit" ];
var connectionSubmit;
var l = window.location;
var base = l.protocol + "//" + l.hostname + ":" + l.port;
var lastValue = {}


    // define fields subject to check, order they occur in form
var requiredConnectionElements = [ "subject", "predicate", "obj", "submit" ];
var connectionElementNames = [ "Subject selector", "Relationship selector",
                               "Object selector" ];

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> error condition present
var connectionFormErrors = {};


if ((typeof inAConnectionsForm !== 'undefined') && inAConnectionsForm){
  connectionSubmit = $('connection_submit');

  lastValue = {
    subject   : $('connection_subject_id').value,
    predicate : $('connection_predicate_id').value,
    obj       : $('connection_obj_id').value
  };

  for (var c=0; c < requiredConnectionElements.length-1; c++)
    connectionFormErrors[requiredConnectionElements[c]] =
      creatingNewConnection ? -1 : false;

  for (var c=0; c < selectElems.length; c++){
    createOnchangeHandler(selectElems[c]);
    createOnfocusHandler(selectElems[c]);
  }

  if (creatingNewConnection)
        // connections/new -- can't submit a blank form
    makeButtonSeemDisabled(connectionSubmit);
  else  // connections/##/edit -- can submit as-is form
    makeButtonSeemEnabled(connectionSubmit);

  connectionSubmit.observe('click', submitOnclickHandler);
}


function createOnchangeHandler(thisName){
  var thisElem = $('connection_' + thisName + '_id');
  if (thisElem == null)
    thisElem = $('connection_' + thisName);
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
          var type = (thisName == "predicate") ? "verb" : "noun";
          itemCreatePopup(thisElem, type, lastLast);
        }
        else {
          clearError(thisName);
          divToWorking(thisName);
          new Ajax.Request(base + "/items/" + thisElem.value + ".json", {
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


function createOnfocusHandler(thisName){
  var thisElem = $('connection_' + thisName + '_id');
  if (thisElem == null)
    thisElem = $('connection_' + thisName);
  thisElem.observe('focus', function(){ onfocusBehavior(thisElem); } );
}

function onfocusBehavior(elem){
  var eId = elem.id;
  var c;
  for (c=0; c < requiredConnectionElements.length; c++){
    var re = new RegExp(requiredConnectionElements[c]);
    var mtch = eId.match(re);
    if (mtch != null && mtch.length > 0)
      break;
  }

  if (c >= requiredConnectionElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  for (c=0; c <= lastToCheck; c++){
    var ck = $("connection_" + requiredConnectionElements[c] + "_id");
    if (ck.value == null || ck.value == "")
      flagConnectionAsRequired(requiredConnectionElements[c]);
    else
      clearError(requiredConnectionElements[c]);
  }
  refreshSubmitState();
}

function flagConnectionAsRequired(elemName){
  connectionFormErrors[elemName] = true;
  $(elemName + "_required").className = "helpTextFlagged";
  $(elemName + "_error_icon").src = "/images/error_error_icon.png";
}

function clearError(elemName){
  connectionFormErrors[elemName] = false;
  $(elemName + "_required").className = "";
  $(elemName + "_error_icon").src = "/images/blank_error_icon.png";
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
