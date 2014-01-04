require! {
  'child_process'.exec
  'event-stream'
  gutil: 'gulp-util'
}

const toPluginError = (reason) ->
  new gutil.PluginError 'gulp-release', reason

const getTemplateData = (file) ->
  'package': file.contents |> String |> JSON.parse
  file: file

const commit = (options) -> event-stream.map !(file, cb) ->
  const {
    files   or <[-a]>
    message or 'Release v<%= package.version %>'
  } = options or {}

  const processedMessage = gutil.template message, getTemplateData(file)
  
  (err, stdout, stderr) <-! exec "git commit #{ files.join ' ' } -m '#{ processedMessage }'"
  if err
    err |> toPluginError |> cb
    return

  gutil.log "committed : #{ processedMessage }"
  cb void, file

const tag = (options) -> event-stream.map !(file, cb) ->
  const {
    name    or '<%= package.version %>'
    message or '<%= package.version %>'
  } = options or {}

  const data = getTemplateData(file)
  const processedName     = gutil.template name, data
  const processedMessage  = gutil.template message, data
  
  (err, stdout, stderr) <-! exec "git tag -a #{ processedName } -m '#{ processedMessage }'"
  if err
    err |> toPluginError |> cb
    return
  
  gutil.log "tagged : #{ processedName }, #{ processedMessage }"
  cb void, file

const push = !(...args) ->
  const cb      = args.pop!
  const options = args.0 or {}
  setTimeout cb, 5000


const publish = !(...args) ->
  const cb      = args.pop!
  const options = args.0 or {}
  setTimeout cb, 5000



const release = (options) ->


module.exports = release <<< {commit, tag, push, publish}