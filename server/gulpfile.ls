require! {
  gulp
  'gulp-nodemon'
}
require! {
  '../client/gulpfile'
}

gulp.task 'server' <[ client ]> !->
  gulp-nodemon do
    script: './index.ls'
    execMap: ls: 'lsc'
    ignore: '../tmp/**'

