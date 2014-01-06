require! {
  gulp
  'gulp-livescript'
  'gulp-bump'
  'gulp-release': './src'
  'gulp-mocha'
  'gulp-clean'
  'gulp-conventional-changelog'
  'event-stream'
}

gulp.task 'compile' ->
  return gulp.src 'src/*.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest 'tmp/'

gulp.task 'clean' ->
  return gulp.src <[tmp/]>
    .pipe gulp-clean!

gulp.task 'test' <[compile]> ->
  return gulp.src 'tmp/spec.js'
    .pipe gulp-mocha!

gulp.task 'build' <[clean]> ->
  return gulp.src 'src/index.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest '.'

gulp.task 'release' <[build]> ->
  const bumpStream = do
    gulp.src 'package.json'
      .pipe gulp-bump bump: 'patch'
      .pipe gulp.dest '.'

  const cgLogStream = do
    event-stream.merge bumpStream, gulp.src 'CHANGELOG.md'
      .pipe gulp-conventional-changelog!
      .pipe gulp.dest '.'

  const releaseStream = gulp-release do
    commit: do
      message: 'chore(release): <%= package.version %>'
      
  packFile = void
  return event-stream.merge bumpStream, cgLogStream
    .pipe event-stream.through !(data) ->
      if packFile
        @pipe releaseStream
        @emit 'data' packFile
      else
        # first come must be package.json
        packFile := data 



