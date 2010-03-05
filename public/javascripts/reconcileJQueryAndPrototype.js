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


// this has to execute between when we load jQuery and when we load Prototype
jQuery.noConflict();         // free-up '$' for 'prototype' (in :defaults)


// these are WontoMedia helpers that need to be available at the top of page
function addToDivsToMove(divId){
  if (typeof divsToMove === 'undefined')
    divsToMove = new Array();
  divsToMove[ divsToMove.length ] = divId;
}

alert_cookie_name = 'show_alert';
