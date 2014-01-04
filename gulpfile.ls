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

gulp.task 'release' <[default]> ->
  return gulp.src 'package.json'
    .pipe gulp-bump 'minor'
    .pipe gulp.dest '.'
    .pipe gulp-release do
      commit: do
        message: 'chore(release): <%= package.version %>'
