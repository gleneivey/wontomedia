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


function nodeCreatePopup(selectElem, nodeType){
  Modalbox.show("/nodes/new-pop?type=" + nodeType, {
    title: "Create a new node",
    height: nodeCreatePopup_Height(),
    width: nodeCreatePopup_Width(),
    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });

selectElem.value="";//temporary no-op
}

function nodeCreatePopup_Height(){
  return document.viewport.getHeight() - 30;
}

function nodeCreatePopup_Width(){
  return Math.floor(document.viewport.getWidth() * 0.62);
}

function nodeCreatePopup_Submit(formId, targetHref){
  Modalbox.show(targetHref, {
    title: "Create a new node",
    height: nodeCreatePopup_Height(),
    width: nodeCreatePopup_Width(),

    method: "post",
    params: Form.serialize(formId),

    overlayClose: false,
    slideDownDuration: 0.25,
    slieUpDuration: 0.1
  });
}

