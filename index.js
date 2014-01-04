(function(){
  var eventStream, gutil, toPluginError, commit;
  eventStream = require('event-stream');
  gutil = require('gulp-util');
  toPluginError = function(reason){
    return new gutil.PluginError('gulp-release', reason);
  };
  commit = function(options){
    return eventStream.map;
  };
}).call(this);
