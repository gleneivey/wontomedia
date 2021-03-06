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


    // invoked at bottom of app/views/layouts/base.html.erb
function moveAndDisplayDelayedDivs(){
  if (typeof divsToMove !== 'undefined')
    for (var c =0; c < divsToMove.length; c++){
      var targetDiv = document.getElementById( divsToMove[c] );
      var divWithAd = document.getElementById( divsToMove[c] + '-content' );

      // remove the ad div from the main document
      var parent = divWithAd.parentNode;
      parent.removeChild( divWithAd );
      // put the ad div into its target location on the page
      targetDiv.appendChild( divWithAd );
      // and make it visible
      divWithAd.style.display = 'block';
    }
}


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
    'width'         : '80%',
    'type'          : 'iframe'
  });
});


function dynamic_alert_show_box(){
  Cookie.set( alert_cookie_name, "false" );
  document.getElementById('alert_box').style.display = 'block';
  document.getElementById('alert_show_link').style.display = 'none';
}

function dynamic_alert_show_link(){
  Cookie.set( alert_cookie_name, "true" );
  document.getElementById('alert_box').style.display = 'none';
  document.getElementById('alert_show_link').style.display = 'block';
}
