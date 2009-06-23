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


require("spec_helper.js");


Screw.Unit(function(){
  describe( "Dynamic input checks in nodes/new page", function(){
    describe( "Visual feedback for Type selection", function(){
      it( "Category selection highlights Category text", function(){
        var d = document.getElementById('test_frame').contentDocument;
        d.getElementById('node_sti_type').value = "ClassNode";

	var e = Element.extend(d.getElementById('category_title'));
	expect(e.getStyle('text-decoration')).to(equal, "none");

	e =     Element.extend(d.getElementById('category_desc'));
	expect(e.getStyle('font-weight')).to(equal, "400");
      });
    });
  });
});

