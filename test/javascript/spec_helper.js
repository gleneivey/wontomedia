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




jQuery.noConflict();
require("../../public/javascripts/prototype.js", {onload: function(){
    require("../../public/javascripts/application.js");
}});


// common helpers for integration tests that load page-under-test into the
// iframe element in "fixture.html"
function IFrame(targetPageUrl){
  document.getElementById('test_frame').src = targetPageUrl;
}
function D(){
  return document.getElementById('test_frame').contentDocument;
}
function E(elementId){
  return D().getElementById(elementId);
}
