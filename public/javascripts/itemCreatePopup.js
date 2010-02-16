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


var nodeSelectElementHavingNewNodeAdded = null;
var nounVerbCodeOfNewNodeBeingAdded = "";
var priorValueOfSelectElementHavingNewNodeAdded = "";

function nodeCreatePopup(selectElem, nodeType, priorValue){
  nodeSelectElementHavingNewNodeAdded = selectElem;
  nounVerbCodeOfNewNodeBeingAdded = nodeType;
  priorValueOfSelectElementHavingNewNodeAdded = priorValue;

  var l = window.location;
  var newpop = l.protocol + "//" + l.hostname + ":" + l.port +
               "/nodes/new-pop?type=" + nodeType;
  Modalbox.show(newpop, {
    title: "Create a new node",
    height: nodeCreatePopup_Height(),
    width: nodeCreatePopup_Width(),
    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });
}

function nodeCreatePopup_Height(){
  return document.viewport.getHeight() - 30;
}

function nodeCreatePopup_Width(){
  return Math.floor(document.viewport.getWidth() * 0.62);
}

function nodeCreatePopup_Submit(buttonElement){
  var l = window.location;
  var postUrl = buttonElement.form.action;
  if (!(postUrl.match(/^http:/)))
    postUrl = l.protocol + "//" + l.hostname + ":" + l.port +
      buttonElement.form.action;

  Modalbox.show(postUrl, {
    title: "Create a new node",
    height: nodeCreatePopup_Height(),
    width: nodeCreatePopup_Width(),

    method: "post",
    params: Form.serialize(buttonElement.form.id),
    afterLoad: nodeCreatePopup_MakeSelection,

    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });
}

function nodeCreatePopup_Cancel(){
  nodeSelectElementHavingNewNodeAdded.value =
    priorValueOfSelectElementHavingNewNodeAdded;
  Modalbox.hide();
}

function nodeCreatePopup_MakeSelection(){
  if (!($('MB_content').innerHTML.match(
      /Node\s+was\s+successfully\s+created/i))){
    nodeSelectElementHavingNewNodeAdded.value =
      priorValueOfSelectElementHavingNewNodeAdded;
    return;
  }

    // grab content of new node
  var idNo = $('node_id').innerHTML;
  var name = $('node_name').innerHTML;
  var title = $('node_title').innerHTML;

    // add new node to all (appropriate) <select> controls
  var controlsToAdd = (nounVerbCodeOfNewNodeBeingAdded == "noun") ?
    [ 'edge_subject_id', 'edge_obj_id' ]                          :
    [ 'edge_subject_id', 'edge_predicate_id', 'edge_obj_id' ];
  for (var c=0; c < controlsToAdd.length; c++){
    var txt = document.createTextNode(name + " : " + title);
    var newOptionElem = document.createElement("option");
    newOptionElem.setAttribute("value", idNo);
    newOptionElem.appendChild(txt);
    $(controlsToAdd[c]).appendChild(newOptionElem);
  }

    // make new node the selection in the operation-originating <select> control
  nodeSelectElementHavingNewNodeAdded.value = idNo;
  nodeSelectElementHavingNewNodeAdded.simulate('change');
  // Note: we're being lazy.  Just setting the value will cause an Ajax
  //    fetch to the server for the node's description.  However, we've
  //    already got it in the nodes/show page content that we're
  //    interrogating for idNo, name, and title.  However, supressing this
  //    fetch would take several lines of code and establish a tight linkage
  //    between here and the on-change logic for <select> elements.

    // close Modalbox
  Modalbox.hide();
}

