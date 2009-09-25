var BLUE_RIDGE_LIB_PREFIX = (environment["blue.ridge.prefix"] ||
                             "../../vendor/plugins/blue-ridge") + "/lib/";
load(BLUE_RIDGE_LIB_PREFIX + "command-line.js");


if(BlueRidge.loaded != true) {
  BlueRidge.loaded = true;

  if(arguments.length == 0) {
    print("Usage: test_runner.js spec/javascripts/file_spec.js");
    quit(1);
  }


  require(BLUE_RIDGE_LIB_PREFIX + "env.rhino.js");
  Envjs.logLevel = Envjs.NONE;       // one of: DEBUG, INFO, WARN, ERROR, NONE


  function executeTest(testWin, prefix, spec){
    loadIntoFnsScope(prefix + "command-line.js");
    loadIntoFnsScope(prefix + "jquery-1.3.2.js");
    loadIntoFnsScope(prefix + "jquery.fn.js");
    loadIntoFnsScope(prefix + "jquery.print.js");
    loadIntoFnsScope(prefix + "screw.builder.js");
    loadIntoFnsScope(prefix + "screw.matchers.js");
    loadIntoFnsScope(prefix + "screw.events.js");
    loadIntoFnsScope(prefix + "screw.behaviors.js");
    loadIntoFnsScope(prefix + "smoke.core.js");
    loadIntoFnsScope(prefix + "smoke.mock.js");
    loadIntoFnsScope(prefix + "smoke.stub.js");
    loadIntoFnsScope(prefix + "screw.mocking.js");
    loadIntoFnsScope(prefix + "consoleReportForRake.js");
    loadIntoFnsScope(spec);
    jQuery(testWin).trigger("load");
  }


  for (var c=0; c < arguments.length; c++){

    BlueRidge.CommandLine.specFile = arguments[c];
    print("Running "        + BlueRidge.CommandLine.specFile +
          " with fixture '" + BlueRidge.CommandLine.fixtureFile + "'...");

    var testWindow = window.open(BlueRidge.CommandLine.fixtureFile);

    /* env.js scope-manipulation magic.  Run "executeTest" as if its
     * _lexical_ scope were within the window we just created, so that it
     * loads all of the component libaries in that context's "window"
     * object and not the one we're executing in here */
    setScope(executeTest, testWindow.__proto__);
    setScope(loadIntoFnsScope, testWindow.__proto__);
    executeTest( testWindow.__proto__, BLUE_RIDGE_LIB_PREFIX,
                 BlueRidge.CommandLine.specFile );

    /* turn script-loading in fixtures "back" off in case last fixture turned
     * it "on".  (Otherwise it would try to load blue-ridge.js, oops.) */
    Envjs.scriptTypes["text/javascript"] = false;
  }
}
