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

if(BlueRidge.loaded != true) {
  if(arguments.length == 0) {
    print("Usage: test_runner.js spec/javascripts/file_spec.js");
    quit(1);
  }
  
  BlueRidge.CommandLine.specFile = arguments[0];

  var require = function(url, options){ return BlueRidge.CommandLine.require(url, options) };
  var debug   = function(message)     { return BlueRidge.CommandLine.debug(message) };

  // Mock up the Firebug API for convenience.
  var console = console || {debug: debug};

  var BLUE_RIDGE_LIB_PREFIX = (environment["blue.ridge.prefix"] || "../../vendor/plugins/blue-ridge") + "/lib/";
  require(BLUE_RIDGE_LIB_PREFIX + "env.rhino.js");

  Envjs(BlueRidge.CommandLine.fixtureFile, {
    log: function(){}
  });

  require(BLUE_RIDGE_LIB_PREFIX + "jquery-1.3.2.js");
  require(BLUE_RIDGE_LIB_PREFIX + "jquery.fn.js");
  require(BLUE_RIDGE_LIB_PREFIX + "jquery.print.js");
  require(BLUE_RIDGE_LIB_PREFIX + "screw.builder.js");
  require(BLUE_RIDGE_LIB_PREFIX + "screw.matchers.js");
  require(BLUE_RIDGE_LIB_PREFIX + "screw.events.js");
  require(BLUE_RIDGE_LIB_PREFIX + "screw.behaviors.js");
  require(BLUE_RIDGE_LIB_PREFIX + "smoke.core.js");
  require(BLUE_RIDGE_LIB_PREFIX + "smoke.mock.js");
  require(BLUE_RIDGE_LIB_PREFIX + "smoke.stub.js");
  require(BLUE_RIDGE_LIB_PREFIX + "screw.mocking.js");
  require(BLUE_RIDGE_LIB_PREFIX + "consoleReportForRake.js");

  print("Running " + BlueRidge.CommandLine.specFile + " with fixture '" + BlueRidge.CommandLine.fixtureFile + "'...");
  BlueRidge.loaded = true;  

  load(BlueRidge.CommandLine.specFile);
  jQuery(window).trigger("load");
}