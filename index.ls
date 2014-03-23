require! {
  gulp
}
require! {
  './gulpfile'
}

gulp.task 'publish' <[ publish:lib publish:changelog ]>

gulp.start 'publish'
