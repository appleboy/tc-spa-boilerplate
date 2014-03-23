require! {
  gulp
  connect
}
require! {
  '../client/gulpfile'
  '../config'
}

gulp.task 'server' <[ client ]> !(done) ->
  connect!
    ..use require('connect-livereload')! unless config.env.is 'production'

    ..use connect.static 'public'
    ..use connect.static 'tmp/public' unless config.env.is 'production'

    ..listen config.port.server, !->
      console.log "connect started at port #{ config.port.server }" &
      done!
