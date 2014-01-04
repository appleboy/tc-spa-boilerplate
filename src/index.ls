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
  const {
    upstream or 'upstream'
  } = args.0 or {}

  (err, stdout, stderr) <-! exec "git push #{ upstream } && git push #{ upstream } --tags"
  if err
    err |> toPluginError |> cb
    return
  
  gutil.log "pushed : #{ upstream }"
  cb!

const publish = !(...args) ->
  const cb      = args.pop!
  # setTimeout cb, 5000
  (err, stdout, stderr) <-! exec "npm publish"
  if err
    err |> toPluginError |> cb
    return
  
  gutil.log "published"
  cb!

const release = (options || {}) ->
  const parallel = event-stream.through !(data) ->
    gutil.log 'data' data
    done = 0
    const end = !~>
      done := done + 1
      @resume! if done is 2
    
    push options.push, end      
    publish end
    @pause!
  #
  # 
  event-stream.pipeline do
    commit options.commit
    tag options.tag
    parallel

module.exports = release <<< {commit, tag, push, publish}