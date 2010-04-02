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


function showInlineConnectionAdd(idStr){
  $('inline-add-'  + idStr + '-link').style.display = 'none';
  $('inline-add-'  + idStr + '-form').style.display = 'block';
  $('object-item-' + idStr          ).style.listStyleType = 'circle';

  var ctrl = $('inline-add-'  + idStr + '-form').down('input[type=text]');
  if (ctrl) ctrl.focus();
  else {
    ctrl = $('inline-add-'  + idStr + '-form').down('select');
    if (ctrl) ctrl.focus();
  }
}

// relies on the fact that the "nothing selected" value for our <select>
// controls is the empty string
function updateControlActivation(ctrl){

  // enable/disable all other connection-object controls
  var allControls = $$('.inline-add');
  var otherControls = new Array();
  for (var c=0; c < allControls.length; c++)
    if (allControls[c] != ctrl)
      otherControls.push(allControls[c]);
  for (var c=0; c < otherControls.length; c++)
    if (ctrl.value == "")    otherControls[c].disabled = false;
    else                     otherControls[c].disabled = true;


  // enable/disable this control's submit button
  var myFormsSubmit = $(ctrl).up('form').down('input[type=submit]');
  if (ctrl.value == "")    myFormsSubmit.disabled = true;
  else                     myFormsSubmit.disabled = false;
}

function selectOnfocusHandler(ctrl){
  ctrl.lastValue = ctrl.value;
}

function selectOnchangeHandler(ctrl, class_item_id){
  updateControlActivation(ctrl);
  if (ctrl.value == "-1")
    itemCreatePopup(ctrl, ctrl.lastValue, null, class_item_id);
}

function textOnchangeHandler(ctrl){
  updateControlActivation(ctrl);
}
