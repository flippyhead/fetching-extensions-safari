({
  paths: {
    requireLib: '../../bower_components/requirejs/require',
    jquery: '../../bower_components/jquery/jquery',
    backbone: '../../bower_components/backbone/backbone',
    underscore: '../../bower_components/underscore/underscore',
    meteor_ddp: '../../bower_components/meteor-ddp/index'
  },
  shim: {
    meteor_ddp: {
      exports: 'MeteorDdp'
    },
    backbone: {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    underscore: {
      exports: '_'
    },
    jquery: {
      exports: 'jQuery'
    }
  },
  include: ['requireLib'],
  name: 'popover',
  out: 'optimized/all.js'
})