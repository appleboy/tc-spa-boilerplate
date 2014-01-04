require! {
  gulp
  'gulp-livescript'
  'gulp-bump'
  'gulp-release': './src'
  'gulp-mocha'
  'gulp-clean'
}

gulp.task 'compile' ->
  return gulp.src 'src/*.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest 'tmp/'

gulp.task 'clean' ->
  return gulp.src <[tmp/]>
    .pipe gulp-clean!

gulp.task 'test' <[compile]> !->
  gulp.src 'tmp/spec.js'
    .pipe gulp-mocha!

gulp.task 'default' <[clean]> !->
  gulp.src 'src/index.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest '.'

#
# release
#
const {commit, tag, push, publish} = gulp-release

gulp.task 'bump' ->
  return gulp.src 'package.json'
    .pipe gulp-bump 'minor'
    .pipe gulp.dest '.'

gulp.task 'commit' ->
  return gulp.src 'package.json'
    .pipe commit message: 'chore(release): <%= package.version %>'

gulp.task 'tag' ->
  return gulp.src 'package.json'
    .pipe tag name: 'V<%= package.version %>V', message: 'chore(release): <%= package.version %>' 

gulp.task 'push' !(cb) ->
  push cb

gulp.task 'publish' !(cb) ->
  publish cb

gulp.task 'release' <[bump commit tag]> !->
  gulp.run 'push', 'publish'