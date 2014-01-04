(function(){
  var exec, eventStream, gutil, toPluginError, getTemplateData, commit, tag, push, publish, release, slice$ = [].slice;
  exec = require('child_process').exec;
  eventStream = require('event-stream');
  gutil = require('gulp-util');
  toPluginError = function(reason){
    return new gutil.PluginError('gulp-release', reason);
  };
  getTemplateData = function(file){
    return {
      'package': JSON.parse(
      String(
      file.contents)),
      file: file
    };
  };
  commit = function(options){
    return eventStream.map(function(file, cb){
      var ref$, files, message, processedMessage;
      ref$ = options || {}, files = ref$.files || ['-a'], message = ref$.message || 'Release v<%= package.version %>';
      processedMessage = gutil.template(message, getTemplateData(file));
      exec("git commit " + files.join(' ') + " -m '" + processedMessage + "'", function(err, stdout, stderr){
        if (err) {
          cb(
          toPluginError(
          err));
          return;
        }
        gutil.log("committed : " + processedMessage);
        cb(void 8, file);
      });
    });
  };
  tag = function(options){
    return eventStream.map(function(file, cb){
      var ref$, name, message, data, processedName, processedMessage;
      ref$ = options || {}, name = ref$.name || '<%= package.version %>', message = ref$.message || '<%= package.version %>';
      data = getTemplateData(file);
      processedName = gutil.template(name, data);
      processedMessage = gutil.template(message, data);
      exec("git tag -a " + processedName + " -m '" + processedMessage + "'", function(err, stdout, stderr){
        if (err) {
          cb(
          toPluginError(
          err));
          return;
        }
        gutil.log("tagged : " + processedName + ", " + processedMessage);
        cb(void 8, file);
      });
    });
  };
  push = function(){
    var args, cb, upstream;
    args = slice$.call(arguments);
    cb = args.pop();
    upstream = (args[0] || {}).upstream || 'upstream';
    exec("git push " + upstream + " && git push " + upstream + " --tags", function(err, stdout, stderr){
      if (err) {
        cb(
        toPluginError(
        err));
        return;
      }
      gutil.log("pushed : " + upstream);
      cb();
    });
  };
  publish = function(){
    var args, cb;
    args = slice$.call(arguments);
    cb = args.pop();
    exec("npm publish", function(err, stdout, stderr){
      if (err) {
        cb(
        toPluginError(
        err));
        return;
      }
      gutil.log("published");
      cb();
    });
  };
  release = function(options){
    var parallel;
    options || (options = {});
    parallel = eventStream.through(function(data){
      var done, end, this$ = this;
      gutil.log('data', data);
      done = 0;
      end = function(){
        done = done + 1;
        if (done === 2) {
          this$.resume();
        }
      };
      push(options.push, end);
      publish(end);
      this.pause();
    });
    return eventStream.pipeline(commit(options.commit), tag(options.tag), parallel);
  };
  module.exports = (release.commit = commit, release.tag = tag, release.push = push, release.publish = publish, release);
}).call(this);
