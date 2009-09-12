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


var selectElems = [ "subject", "predicate", "obj" ];
var submit = $('node_submit');

var lastValue = {
  subject   : "",
  predicate : "",
  obj       : ""
};

var l = window.location;
var base = l.protocol + "//" + l.hostname + ":" + l.port;

for (var c=0; c < selectElems.length; c++)
  createOnchangeHandler(selectElems[c]);

function createOnchangeHandler(thisName){
  var thisElem = $('edge_' + thisName + '_id');
  thisElem.observe('change',
    function(){                       // nest all these fn defs for closure
      if (thisElem.value != lastValue[thisName]){
        lastValue[thisName] = thisElem.value;
        if (thisElem.value == "")
          divToBlank(thisName);
        else {
          divToWorking(thisName);
          new Ajax.Request(base + "/nodes/" + thisElem.value + ".json", {
            method: 'get',
            onSuccess: function(response){
              var nodeObject = response.responseJSON;
              var key = getFirstHashKey(nodeObject)
              divToText(thisName, nodeObject[key]["description"]);
            },
            onFailure: function(){
              divToBlank(thisName);
            }
          });
        }
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
    "     src='/images/" + imageName + "_status_icon.png'>";
}

function divToText(divName, divText){
  if (divText === undefined || divText == null)
    divText = "";
  $(divName + '_desc').className = "";
  $(divName + '_desc').innerHTML = "<p>" + divText.escapeHTML() + "</p>";
}
