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


var selectElems = [ "subject", "predicate", "obj", "submit" ];
var edgeSubmit = $('edge_submit');
var l = window.location;
var base = l.protocol + "//" + l.hostname + ":" + l.port;

var lastValue = {
  subject   : $('edge_subject_id').value,
  predicate : $('edge_predicate_id').value,
  obj       : $('edge_obj_id').value
};


    // define fields subject to check, order they occur in form
var requiredEdgeElements = [ "subject", "predicate", "obj", "submit" ];
var edgeElementNames = [ "Subject selector", "Relationship selector",
                          "Object selector" ];

    // encoding: -1    -> haven't checked yet
    //           false -> no error
    //           true  -> error condition present
var edgeFormErrors = {};
for (var c=0; c < requiredEdgeElements.length-1; c++)
  edgeFormErrors[requiredEdgeElements[c]] = creatingNewEdge ? -1 : false;



for (var c=0; c < selectElems.length; c++){
  createOnchangeHandler(selectElems[c]);
  createOnfocusHandler(selectElems[c]);
}


if (creatingNewEdge)
  makeButtonSeemDisabled(edgeSubmit); // edges/new -- can't submit a blank form
else
  makeButtonSeemEnabled(edgeSubmit);  // edges/##/edit -- can submit as-is form


edgeSubmit.observe('click', submitOnclickHandler);





function createOnchangeHandler(thisName){
  var thisElem = $('edge_' + thisName + '_id');
  if (thisElem == null)
    thisElem = $('edge_' + thisName);
  thisElem.observe('change',
    function(){                       // nest all these fn defs for closure
      if (thisElem.value != lastValue[thisName]){
        lastValue[thisName] = thisElem.value;
        if (thisElem.value == ""){
          divToBlank(thisName);
          flagEdgeAsRequired(thisName);
        }
        else if (thisElem.value == "-1"){
          divToBlank(thisName);
          var type = (thisName == "predicate") ? "verb" : "noun";
          nodeCreatePopup(thisElem, type);
        }
        else {
          clearError(thisName);
          divToWorking(thisName);
          new Ajax.Request(base + "/nodes/" + thisElem.value + ".json", {
            method: 'get',
            onSuccess: function(response){
              var nodeObject = response.responseJSON;
              var key = getFirstHashKey(nodeObject);
              divToText(thisName, nodeObject[key]["description"]);
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
  var thisElem = $('edge_' + thisName + '_id');
  if (thisElem == null)
    thisElem = $('edge_' + thisName);
  thisElem.observe('focus', function(){ onfocusBehavior(thisElem); } );
}

function onfocusBehavior(elem){
  var eId = elem.id;
  var c;
  for (c=0; c < requiredEdgeElements.length; c++){
    var re = new RegExp(requiredEdgeElements[c]);
    var mtch = eId.match(re);
    if (mtch != null && mtch.length > 0)
      break;
  }

  if (c >= requiredEdgeElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  for (c=0; c <= lastToCheck; c++){
    var ck = $("edge_" + requiredEdgeElements[c] + "_id");
    if (ck.value == null || ck.value == "")
      flagEdgeAsRequired(requiredEdgeElements[c]);
    else
      clearError(requiredEdgeElements[c]);
  }
  refreshSubmitState();
}

function flagEdgeAsRequired(elemName){
  edgeFormErrors[elemName] = true;
  $(elemName + "_required").className = "helpTextFlagged";
  $(elemName + "_error_icon").src = "/images/error_error_icon.png";
}

function clearError(elemName){
  edgeFormErrors[elemName] = false;
  $(elemName + "_required").className = "";
  $(elemName + "_error_icon").src = "/images/blank_error_icon.png";
}

function refreshSubmitState(){
  var detectedAtLeastOneError = false;
  for (var c =0; c < requiredEdgeElements.length-1; c++)
    if (edgeFormErrors[requiredEdgeElements[c]] != false)
      detectedAtLeastOneError = true;

  if (detectedAtLeastOneError)
    makeButtonSeemDisabled(edgeSubmit);
  else
    makeButtonSeemEnabled(edgeSubmit);
}


function submitOnclickHandler(ev){
  onfocusBehavior(edgeSubmit);
  var dialogDisplayed = maybeShowErrorDialog();
  if (dialogDisplayed)
    ev.stop();
}

function maybeShowErrorDialog(){
  var newDialogText = "<p>";

  var accum = false;
  for (var c=0; c < requiredEdgeElements.length-1; c++){
    if (edgeFormErrors[requiredEdgeElements[c]] == true){
      accum = true;
      newDialogText += "The " + edgeElementNames[c] + " must have a value. ";
    }
  }

  if (accum){
    newDialogText += "</p>";
    var titleText =
      creatingNewEdge ? "Can't create this edge yet" : "Can't update this edge";
    Modalbox.show(newDialogText, { title: titleText,
                                   slideDownDuration: 0.25,
                                   slideUpDuration: 0.1 } );
  }
  return accum;
}


