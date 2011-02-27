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


require("spec_helper.js");


var testType = "IndividualItem";
function getCurrentType(){ return testType; }

Screw.Unit(function(){
  describe( "Conversion of Title strings to Name strings", function(){
    it( "Ignores non-letters at the beginning of Title", function(){
      for (var c=0x20; c < 0x7f; c++)
        if ((c >= 0x41 && c <= 0x5a) ||
            (c >= 0x61 && c <= 0x7a)    )
          ; // do nothing for alphabetic characters
        else
          expect(genNameValue(String.fromCharCode(c) + "a title")).to(
            equal, "ATitle");

      var someNonAlphaChars = [ " ", "2", "+", "7", ".", "\t", ",", ":",
                                "-", "9", "_", "&", "1", "[", ">" ];
      for (var c = 1; c <= 20; c++){
        var prefix = "";
        for (var cn = 0; cn < c; cn++)
          prefix += someNonAlphaChars[(c+cn) % someNonAlphaChars.length];
        expect(genNameValue(prefix + "a title")).to(equal, "ATitle");
      }
    });

    it( "Truncates the generated Name to 80 characters", function(){
      var longInput = "Now is the time for all good men to come to the aid of their parties.   Now is the time for all good men to come to the aid of their parties.";
      var longOutput = "nowIsTheTimeForAllGoodMenToComeToTheAidOfTheirParties_NowIsTheTimeForAllGoodMenToComeToTheAidOfTheirParties";
      var firstC = longOutput.substr(0,1);

               // these constants match the strings above
      for (var inCt=99, outCt=75; outCt < longOutput.length; inCt++,outCt++){
        while (longInput.charAt(inCt) == " ")
          inCt++;

        var lowerCase = ((inCt % 2) == 0);
        testType = lowerCase ? "PropertyItem" : "IndividualItem";

        var inpt = longInput.substr(0, inCt);
        var len = (outCt > 80) ? 80 : outCt;
        var outpt = longOutput.substr(0, len);

        firstC = lowerCase ? firstC.toLowerCase() : firstC.toUpperCase();
        outpt = outpt.replace(/^./, firstC);

        expect(genNameValue(inpt)).to(equal, outpt);
      }
    });

    it( "Generates CamelCase Names", function(){
      var testCases = [
        { inStr: " now is the time ",
            outStr: "NowIsTheTime",
            type: "CategoryItem" },
        { inStr: ">Item-title isn't lONG<",
            outStr: "ItemTitleIsntLong",
            type: "IndividualItem" },
        { inStr: "Title of \"a item\"is longer",
            outStr: "titleOfAItemIsLonger",
            type: "PropertyItem" },
        { inStr: "This is      a     String--With lots of    space",
            outStr: "ThisIsAStringWithLotsOfSpace",
            type: "CategoryItem" },
        { inStr: "This!title@&has#*(words$)-=delimited%_+[:;by^|\\punctuation!",
            outStr: "This_Title_Has_Words_Delimited_By_Punctuation",
            type: "IndividualItem" },
        { inStr: "A item  (wItH SurPrisE)",
            outStr: "aItem_WithSurprise_",
            type: "PropertyItem" }
      ];

      for (var c=0; c < testCases.length; c++){
        testType = testCases[c].type;
        expect(genNameValue(testCases[c].inStr)).to(equal,
          testCases[c].outStr);
      }
    });

    it( "Ignores non-) punctuation and whitespace at end of Title", function(){
      testType = "CategoryItem";
      var inStr  = "A title str";
      var outStr = "ATitleStr";
      var iS, oS;

      for (var c=0x20; c < 0x7f; c++){
        iS = inStr + String.fromCharCode(c);

        if ((c >= 0x30 && c <= 0x39) ||
            (c >= 0x41 && c <= 0x5a) ||
            (c >= 0x61 && c <= 0x7a)   )
          oS = outStr + String.fromCharCode(c).toLowerCase();
        else if (String.fromCharCode(c) == ")")
          oS = outStr + "_";
        else
          oS = outStr;

        expect(genNameValue(iS)).to(equal, oS);
      }
    });

    it( "Ignores single quotes, any position", function(){
      testType = "PropertyItem";
      var inStr  = "A title str";
      var outStr = "aTitleStr";
      var iS;

      for (var c=0; c <= inStr.length; c++){
        iS = inStr.substr(0, c) + "'" + inStr.substr(c, inStr.length-c);
        expect(genNameValue(iS)).to(equal, outStr);
      }
    });

    it( "Handles digits, any position", function(){
      testType = "IndividualItem";
      var inStr  = "A longer title string is more interesting";
      var outStr = "ALongerTitleStringIsMoreInteresting";
      var iS, oS;

      var outCt = 0;
      for (var inCt=0; inCt <= inStr.length; inCt++){
        var digit = String.fromCharCode(0x30 + (inCt%10));
        iS = inStr.substr(0, inCt) + digit +
             inStr.substr(inCt, inStr.length-inCt);
        if (outCt == 0)
          oS = outStr;
        else
          oS = outStr.substr(0, outCt) + digit +
               outStr.substr(outCt, 1).toUpperCase() +
               outStr.substr(outCt+1, inStr.length-(outCt+1));
        expect(genNameValue(iS)).to(equal, oS);

        if (inStr.substr(inCt,1) != " ")
          outCt++;
      }
    });
  });

  describe( "Auto-generation of Name.value on Title updates", function(){
    it( "Auto-generates at the beginning", function(){
      // depends on containing page "knowing" whether it is OK to auto-generate
      // and having set 'genNameFromTitleOk = true' if so.

      var titleElem = document.getElementById('title');
      var nameElem  = document.getElementById('name');
      testType = "PropertyItem";
      changeFieldToValue(titleElem,
                         "1 Title string--turns into short'r name string.");
      expect(nameElem.value).to(equal, "titleStringTurnsIntoShortrNameString");
    });

    it( "Auto-generates incrementally", function(){

      var titleElem = document.getElementById('title');
      var nameElem  = document.getElementById('name');
      testType = "CategoryItem";

      var inStr  =
        "This title string does not have any tricky characters besides space";
      var outStr = "ThisTitleStringDoesNotHaveAnyTrickyCharactersBesidesSpace";
      var iS, oS;

      var outCt = 0;
      for (var inCt=0; inCt <= inStr.length; inCt++){
        iS = inStr.substr(0, inCt);
        oS = outStr.substr(0, outCt);

        changeFieldToValue(titleElem, iS);
        expect(nameElem.value).to(equal, oS);

        if (inStr.substr(inCt,1) != " ")
          outCt++;
      }
    });

    it( "Stops auto-generation if Name edited, resumes if cleared", function(){

      var titleElem = document.getElementById('title');
      var nameElem  = document.getElementById('name');
      testType = "IndividualItem";

      var inStr  = "another  long title with   spaces";
      var outStr = "AnotherLongTitleWithSpaces";
      var iS, oS;

      var stopGenAt = 10;
      var restartGenAt = 20;
      var restarted = false;

      var outCt = 0;
      for (var inCt=0; inCt <= inStr.length; inCt++){
        iS = inStr.substr(0, inCt);
        oS = outStr.substr(0, outCt);

        if (outCt == stopGenAt)
          changeFieldToValue(nameElem, "fred");
        if (outCt == restartGenAt && !restarted){
          restarted = true;
          changeFieldToValue(nameElem, "");
        }
        changeFieldToValue(titleElem, iS);

        if (outCt >= stopGenAt && outCt < restartGenAt)
          expect(nameElem.value).to(equal, "fred");
        else
          expect(nameElem.value).to(equal, oS);

        if (inStr.substr(inCt,1) != " ")
          outCt++;
      }
    });
  });
});

