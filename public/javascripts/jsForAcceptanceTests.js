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


// return "true" if at least one element matching the selector has
// style.display!=none and all ancestor elements are style.display!=none
function isDisplayedMatchOfSelector(selector_string){
  elements = jQuery(selector_string);

   perElementLoop:
  for (var c=0; c < elements.length; c++){

    var lastE = null;
    for (var e=elements[c]; e != null && e != lastE; e = e.parentNode){
      if (e.style && e.style.display == 'none')
        continue perElementLoop;
      lastE = e;
    }

    // all != 'none', so we're done
    return true;
  }

  return false;
}
