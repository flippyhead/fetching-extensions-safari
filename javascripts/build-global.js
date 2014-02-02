
({
  paths: {
    requireLib: "../../bower_components/requirejs/require",
    jquery: "../../bower_components/jquery/jquery",
    backbone: "../../bower_components/backbone/backbone",
    underscore: "../../bower_components/underscore/underscore"
  },
  shim: {
    jquery: {
      exports: "jQuery"
    },
    backbone: {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    }
  },
  include: ["requireLib"],
  name: "global",
  out: "optimized/global.js"
})
