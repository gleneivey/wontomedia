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


// package of code to implement required-inputs-can't-be-empty checks
//   (for nodes/new page)

    // define fields subject to check, order they occur in form
var requiredInputElements = [ "sti_type", "title", "name",
                              "description", "submit" ];

    // validation function
function checkRequiredFields(e){
  var eId = e.id;
  var c;
  for (c=0; c   <  requiredInputElements.length &&
            eId != "node_" + requiredInputElements[c];    c++)
    ;

  if (c == 0 || c >= requiredInputElements.length)
    return;  // Hmmmm..... maybe not

  var lastToCheck = c-1;
  for (c=0; c <= lastToCheck; c++){
    ck = $("node_" + requiredInputElements[c]);
    if (ck.value === undefined || ck.value == null || ck.value == ""){
      var req = $(requiredInputElements[c] + "_required");
      if ( req != null ){
        req.className = "helpTextFlagged";
        $(requiredInputElements[c] + "_error_icon").src =
          "/images/error_error_icon.png";
      }
      else {
        $(requiredInputElements[c] + "_recommended").className =
          "helpTextFlagged";
        $(requiredInputElements[c] + "_error_icon").src =
          "/images/warn_error_icon.png";
      }
    }
  }
}

    // plumb validation function to relevant elements
var a = $('node_sti_type');    a.onfocus= function(){checkRequiredFields(a);};
var b = $('node_title');       b.onfocus= function(){checkRequiredFields(b);};
var c = $('node_name');        c.onfocus= function(){checkRequiredFields(c);};
var d = $('node_description'); d.onfocus= function(){checkRequiredFields(d);};
var e = $('node_submit');      e.onfocus= function(){checkRequiredFields(e);};

