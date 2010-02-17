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





// expect host page to define the variable 'genNameFromTitleOk' and
//   the function 'getCurrentType()'


function generateFromTitle(titleInputElem, nameInputElem){
  var result = false;
  if (genNameFromTitleOk && titleInputElem.value != null){
    if (nameInputElem.value == null ||
        nameInputElem.value == "")
      result = true;

    nameInputElem.value = genNameValue(titleInputElem.value);
    clearNameUniquenessIndicators();
  }
  return result;
}

function generateToName(titleInputElem, nameInputElem){
  if (genNameFromTitleOk && titleInputElem.value != null){
    if (nameInputElem.value != genNameValue(titleInputElem.value))
      genNameFromTitleOk = false;
  }
  else
    if (nameInputElem.value == null || nameInputElem.value == "")
      genNameFromTitleOk = true;
}

function genNameValue(titleText){
  function doesMatch(str, re){
    var mtch = str.match(re);
    if (mtch == null || mtch.length == 0)
      return false;
    else
      return true;
  }

  var wordBound = true;
  if (getCurrentType() == "PropertyItem")
    wordBound = false;

  var atStart = true;
  var lastWasPunct = false;
  var gotCloseParen = false;
  var outCount = 0;
  var nameText = "";
  var cr;
  for (var c=0; c < titleText.length; c++){
    cr = titleText.charAt(c);

    if (atStart && !doesMatch(cr, /[a-zA-Z]/))
      ;    // ignore character
    else if (doesMatch(cr, /'/))
      ;    // ignore character
    else if (doesMatch(cr, /\s|"|-/))
      wordBound = true;
    else if (!doesMatch(cr, /[a-zA-Z0-9]/)){
      if (cr == ")")
        gotCloseParen = true;

      if (lastWasPunct)
        ;    // ignore character
      else {
        atStart = false;
        lastWasPunct = true;
        wordBound = true;
        outCount++;
        nameText += "_";
      }
    }
    else if (doesMatch(cr, /[0-9]/)){
      lastWasPunct = false;
      gotCloseParen = false;
      wordBound = true;
      outCount++;
      nameText += cr;
    }
    else {
      atStart = false;
      lastWasPunct = false;
      gotCloseParen = false;
      outCount++;
      if (wordBound){
        nameText += cr.toUpperCase();
        wordBound = false;
      }
      else
        nameText += cr.toLowerCase();
    }

    if (outCount >= 80)
      return nameText;
  }

  if (nameText.substr(nameText.length - 1, 1) == "_" && !gotCloseParen)
    return nameText.substr(0, nameText.length - 1);
  return nameText;
}

