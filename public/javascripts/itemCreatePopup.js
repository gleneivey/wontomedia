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


var itemSelectElementHavingNewItemAdded = null;
var nounVerbCodeOfNewItemBeingAdded = "";
var priorValueOfSelectElementHavingNewItemAdded = "";

function itemCreatePopup(selectElem, itemType, priorValue){
  itemSelectElementHavingNewItemAdded = selectElem;
  nounVerbCodeOfNewItemBeingAdded = itemType;
  priorValueOfSelectElementHavingNewItemAdded = priorValue;

  var l = window.location;
  var newpop = l.protocol + "//" + l.hostname + ":" + l.port +
               "/items/new-pop?type=" + itemType;
  Modalbox.show(newpop, {
    title: "Create a new item",
    height: itemCreatePopup_Height(),
    width: itemCreatePopup_Width(),
    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });
}

function itemCreatePopup_Height(){
  return document.viewport.getHeight() - 30;
}

function itemCreatePopup_Width(){
  return Math.floor(document.viewport.getWidth() * 0.62);
}

function itemCreatePopup_Submit(buttonElement){
  var l = window.location;
  var postUrl = buttonElement.form.action;
  if (!(postUrl.match(/^http:/)))
    postUrl = l.protocol + "//" + l.hostname + ":" + l.port +
      buttonElement.form.action;

  Modalbox.show(postUrl, {
    title: "Create a new item",
    height: itemCreatePopup_Height(),
    width: itemCreatePopup_Width(),

    method: "post",
    params: Form.serialize(buttonElement.form.id),
    afterLoad: itemCreatePopup_MakeSelection,

    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });
}

function itemCreatePopup_Cancel(){
  itemSelectElementHavingNewItemAdded.value =
    priorValueOfSelectElementHavingNewItemAdded;
  Modalbox.hide();
}

function itemCreatePopup_MakeSelection(){
  if (!($('MB_content').innerHTML.match(
      /Item\s+was\s+successfully\s+created/i))){
    itemSelectElementHavingNewItemAdded.value =
      priorValueOfSelectElementHavingNewItemAdded;
    return;
  }

    // grab content of new item
  var idNo = $('item_id').innerHTML;
  var name = $('item_name').innerHTML;
  var title = $('item_title').innerHTML;

    // add new item to all (appropriate) <select> controls
  var controlsToAdd = (nounVerbCodeOfNewItemBeingAdded == "noun") ?
    [ 'connection_subject_id', 'connection_obj_id' ]               :
    [ 'connection_subject_id', 'connection_predicate_id', 'connection_obj_id' ];
  for (var c=0; c < controlsToAdd.length; c++){
    var txt = document.createTextNode(name + " : " + title);
    var newOptionElem = document.createElement("option");
    newOptionElem.setAttribute("value", idNo);
    newOptionElem.appendChild(txt);
    $(controlsToAdd[c]).appendChild(newOptionElem);
  }

    // make new item the selection in the operation-originating <select> control
  itemSelectElementHavingNewItemAdded.value = idNo;
  itemSelectElementHavingNewItemAdded.simulate('change');
  // Note: we're being lazy.  Just setting the value will cause an Ajax
  //    fetch to the server for the item's description.  However, we've
  //    already got it in the items/show page content that we're
  //    interrogating for idNo, name, and title.  However, supressing this
  //    fetch would take several lines of code and establish a tight linkage
  //    between here and the on-change logic for <select> elements.

    // close Modalbox
  Modalbox.hide();
}

