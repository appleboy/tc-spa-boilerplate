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
  upstream = (args[0] || {}).upstream || 'origin';
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
  var parallel, streams;
  options || (options = {});
  parallel = eventStream.through(function(data){
    var done, count, end, this$ = this;
    done = count = 0;
    end = function(){
      done = done + 1;
      if (done === count) {
        this$.resume();
      }
    };
    if (options.push !== false) {
      count += 1;
      push(options.push, end);
    }
    if (options.publish !== false) {
      count += 1;
      publish(end);
    }
    this.pause();
  });
  streams = [];
  if (options.commit !== false) {
    streams.push(commit(options.commit));
  }
  if (options.tag !== false) {
    streams.push(tag(options.tag));
  }
  streams.push(parallel);
  return eventStream.pipeline.apply(eventStream, streams);
};
module.exports = (release.commit = commit, release.tag = tag, release.push = push, release.publish = publish, release);