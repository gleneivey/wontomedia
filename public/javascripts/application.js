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



// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



    // common to several forms
function makeButtonSeemEnabled(button){
  button.className = "activeButton";
}
function makeButtonSeemDisabled(button){
  button.className = "inactiveButton";
}


    // common uses for modalbox
function cantDeleteItem_Popup(){
  Modalbox.show(
    "<p>An item cannot be deleted as long as it is referenced by a " +
      "connection. Change or delete all of the connections referencing " +
      "this item first if you want to delete this item.</p>",
    { title: "Cannot delete this item now",
      slideDownDuration: 0.25, slideUpDuration: 0.1 } );
}


    // establish special class making links use fancybox
jQuery(document).ready(function() {
  jQuery('.iframeBox').fancybox({
    'titlePosition' : 'inside',
    'titleFormat'   : function(){ return "<span class='blue-text'>" +
                        "Click outside box or type 'ESC' to close</span>"; },
    'transitionIn'  : 'elastic',
    'transitionOut' : 'elastic',
    'type'          : 'iframe'
  });
});

