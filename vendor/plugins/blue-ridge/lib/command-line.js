var BlueRidge = BlueRidge || {};

BlueRidge.CommandLine = {
  require: function(file, options){
    load(this.prepareFilenameForRequireBasedOnSpecDirectory(file));

    options = options || {};
    if(options['onload']) {
      options['onload'].call();
    }
  },

  debug: function(message){
    print(message);
  },

  prepareFilenameForRequireBasedOnSpecDirectory: function(filename){
    if(filename == null || filename[0] == "/") { return filename; }
    return (this.specDirname == null) ? filename : (this.specDirname + "/" + filename);
  },

  get fixtureFile(){
    var failName = this.specFile.replace(/^(.*?)_spec\.js$/, "$1.html");
    var workingName = this.specFile.replace(/\.js$/, ".html");

    var fileStr, foundFlag = false;
    while (!foundFlag && workingName.indexOf("_") != -1){
      workingName = workingName.replace(/^(.*?)_[^_]+\.html$/, "$1.html");
      foundFlag = true;
      try {        readFile("fixtures/" + workingName);    }
        catch (e){ foundFlag = false;                      }
    }

    if (foundFlag)
      return "fixtures/" + workingName;
    else {
      try {        readFile("fixture.html");         }
        catch (e){ return "fixtures/" + failName;    }
      return "fixture.html";
    }
  },

  get specDirname(){
    if(this.specFile == null) { return null; }
    var pathComponents = this.specFile.split("/");
    var filename = pathComponents.pop();
    return (pathComponents.length > 0) ? pathComponents.join("/") : null;
  },

  get specBasename(){
    if(this.specFile == null) { return null; }
    return this.specFile.split("/").pop();
  },

  exampleName: function(element){
    var exampleName = jQuery.trim(jQuery(element).children("h2").text());

    var names = this.contextNamesForExample(element);
    names.push(exampleName);

    return names.join(" ");
  },

  contextNamesForExample: function(element){
    var describes = jQuery(element).parents('.describe').children('h1');

    var contextNames = jQuery.map(describes, function(context){
      return jQuery.trim(jQuery(context).text());
    });

    return contextNames.reverse();
  }
};

var require = function(url, options){
  return BlueRidge.CommandLine.require(url, options) };
var debug = function(message){
  return BlueRidge.CommandLine.debug(message) };
var console = console || {debug: debug};  // Mock Firebug API for convenience
