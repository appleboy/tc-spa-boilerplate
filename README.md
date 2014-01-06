# gulp-release

[![NPM version](https://badge.fury.io/js/gulp-release.png)](http://badge.fury.io/js/gulp-release) [![Build Status](https://secure.travis-ci.org/tomchentw/gulp-release.png)](http://travis-ci.org/tomchentw/gulp-release) [![Code Climate](https://codeclimate.com/github/tomchentw/gulp-release.png)](https://codeclimate.com/github/tomchentw/gulp-release) [![Dependency Status](https://gemnasium.com/tomchentw/gulp-release.png)](https://gemnasium.com/tomchentw/gulp-release)

A gulp friendly release helper.


## Usage

We recommend you use [`gulp-bump`](https://github.com/stevelacy/gulp-bump) as your version bumping library. Examples:  

```javascript
var gulpLivescript = require('gulp-livescript'),
    gulpBump = require('gulp-bump'),
    gulpRelease = require('gulp-release');

gulp.task('default', function(){
  gulp.src('src/index.ls').pipe(gulpLivescript()).pipe(gulp.dest('.'));
});
gulp.task('release', ['default'], function(){
  return gulp.src('package.json')
    .pipe(gulpBump({ bump: 'patch' }))
    .pipe(gulp.dest('.'))
    .pipe(gulpRelease({
      commit: {
        message: 'chore(release): <%= package.version %>'
      },
      publish: false // explicitly pass false will skip this step
    }));
});
```

### Seperate task
Yes, we know that you may want some fine tune before release a new version:  

```javascript
var gulpLivescript = require('gulp-livescript'),
    gulpBump = require('gulp-bump'),
    gulpRelease = require('gulp-release'),
    commit  = gulpRelease.commit,
    tag     = gulpRelease.tag,
    push    = gulpRelease.push,
    publish = gulpRelease.publish;

gulp.task('bump', function(){
  return gulp.src('package.json')
    .pipe(gulpBump({ bump: 'patch' }))
    .pipe(gulp.dest('.'));
});
gulp.task('commit', ['bump'], function(){
  return gulp.src('package.json').pipe(commit({
    message: 'chore(release): <%= package.version %>'
  }));
});
gulp.task('tag', ['commit'], function(){
  return gulp.src('package.json').pipe(tag());
});
gulp.task('push', function(cb){
  push(cb);
});
gulp.task('publish', function(cb){
  publish(cb);
});
gulp.task('release', ['tag'], function(){
  gulp.run('push', 'publish');
});
``` 

Notice that `push` and `publish` are [**callback**](https://github.com/gulpjs/gulp#accept-a-callback) based asynchronous,  
`commit` and `tag` are [**stream**](https://github.com/gulpjs/gulp#return-a-stream) based and both require `package.json` to be piped in.

## Options

As you can see, the `gulp-release` contains four parts, and can be configured seperately:

```javascript
{
  commit: {},
  tag: {},
  push: {},
  publish: false // explicitly pass false will skip this step
}
```
Pass `false` to skip the step, other value except `false` will execute that step (yes, even `undefined`).

### options.commit
```javascript
{
  files: ['-a'],
  message: 'Release v<%= package.version %>'
}
```

#### files
List of files to commit.

#### message
A [gulp-util template](https://github.com/gulpjs/gulp-util#templatestring-data) string, available local variables are:

* `package`: parsed package.json
* `file`: gulp file of package.json (it's required by `gulp-util` template function)

### options.tag
```javascript
{
  name: '<%= package.version %>',
  message: '<%= package.version %>'
}
```

Both `name` and `message` are [gulp-util template](https://github.com/gulpjs/gulp-util#templatestring-data) strings, available local variables are:

* `package`: parsed package.json
* `file`: gulp file of package.json (it's required by `gulp-util` template function)

#### name
annotated tag, needs a message : `git tag -a #{ name }`

#### message
tag message : `git tag -m #{ message }`


### options.push
```javascript
{
  upstream: 'origin'
}
```

#### upstream
where this release will be pushed to : `git push #{ upstream }`


### options.publish
```javascript
{
  publish: true
}
```

Will publish this package to `npm`.

## Contributing

[![devDependency Status](https://david-dm.org/tomchentw/gulp-release/dev-status.png?branch=master)](https://david-dm.org/tomchentw/gulp-release#info=devDependencies)

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

* [`grunt-release` by @geddski](https://github.com/geddski/grunt-release)
* [`grunt-bump` by @vojtajina](https://github.com/vojtajina/grunt-bump)