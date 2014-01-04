# gulp-release

[![NPM version](https://badge.fury.io/js/gulp-release.png)](http://badge.fury.io/js/gulp-release) [![Build Status](https://secure.travis-ci.org/tomchentw/gulp-release.png)](http://travis-ci.org/tomchentw/gulp-release) [![Code Climate](https://codeclimate.com/github/tomchentw/gulp-release.png)](https://codeclimate.com/github/tomchentw/gulp-release)

LiveScript plugin for gulp


## Usage

```javascript
var gulpLiveScript = require('gulp-release');

gulp.task('ls', function() {
  gulp.src('./src/*.ls')
    .pipe(gulpLiveScript({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./public/'));
});

```

### Error Handling

`gulp-release` will emit an error for cases such as invalid LiveScript syntax. If uncaught, the error will crash gulp.

You will need to attach a listener (i.e. .on('error')) for the error event emitted by gulp-release. Since .on(...) returns this, you can compact it as inline code (See [Usage](https://github.com/tomchentw/gulp-release/blob/master/README.md#Usage)).

### Options

The options object supports the same options as the standard LiveScript compiler.


## Contributing

[![devDependency Status](https://david-dm.org/tomchentw/gulp-release/dev-status.png?branch=master)](https://david-dm.org/tomchentw/gulp-release#info=devDependencies)

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
