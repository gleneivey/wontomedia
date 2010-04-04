var BLUE_RIDGE_PREFIX = (
  environment["blue.ridge.prefix"] || "../../vendor/plugins/blue-ridge" );
var BLUE_RIDGE_LIB_PREFIX    = BLUE_RIDGE_PREFIX + "/lib/";
var BLUE_RIDGE_VENDOR_PREFIX = BLUE_RIDGE_PREFIX + "/vendor/";
load( BLUE_RIDGE_LIB_PREFIX + "command-line.js" );

if(BlueRidge.loaded != true) {
  BlueRidge.loaded = true;  

  if(arguments.length == 0) {
    print("Usage: test_runner.js spec/javascripts/file_spec.js");
    quit(1);
  }
  
  BlueRidge.CommandLine.specFile = arguments[0];

  require(BLUE_RIDGE_VENDOR_PREFIX + "env.rhino.js");
  Envjs.logLevel = Envjs.ERROR;       // one of: DEBUG, INFO, WARN, ERROR, NONE

  require(BLUE_RIDGE_VENDOR_PREFIX + "jquery-1.4.2.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "jquery.fn.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "jquery.print.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "screw.builder.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "screw.matchers.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "screw.events.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "screw.behaviors.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "smoke.core.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "smoke.mock.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "smoke.stub.js");
  require(BLUE_RIDGE_VENDOR_PREFIX + "screw.mocking.js");
  require(BLUE_RIDGE_LIB_PREFIX + "consoleReportForRake.js");
  
  print("Running " + BlueRidge.CommandLine.specFile + " with fixture '" + BlueRidge.CommandLine.fixtureFile + "'...");
  
  Envjs(BlueRidge.CommandLine.fixtureFile, {
    loadInlineScript: function(){},
    log: function(){}
  });

  load(BlueRidge.CommandLine.specFile);
  jQuery(window).trigger("load");
  Envjs.wait();
}