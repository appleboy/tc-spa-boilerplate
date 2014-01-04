require! {
  fs
  'child_process'.exec
  path.join
  'gulp-release': './index'
  gulp
  gutil: 'gulp-util'
  mocha
  should
}

(...) <-! describe 'gulp-release'
const {commit, tag, push, publish} = gulp-release

describe 'commit' !(...) ->
  lastCommit = void
  beforeEach !(done) ->
    const commands =
      * 'git rev-parse master 1>&2'
      * 'echo "\n## another line ..." >> misc/fixture.md'

    (err, stdout, stderr) <-! exec commands.join(' && ')
    lastCommit := stderr.toString!trim!
    done err

  afterEach !(done) ->
    exec "git reset #{ lastCommit } && git checkout .", done
    lastCommit := void

  const checkLastParent = "git rev-list --parents --max-count=1 master | grep "

  it 'should work with default options' !(done) ->
    const stream = commit!
    stream.on 'data' !->
      (err, stdout) <- exec "#{ checkLastParent }#{ lastCommit }"
      should.exist stdout.toString!trim!
      done err
    
    gulp.src 'package.json' .pipe stream

describe 'tag' !(...) ->
  const checkLastTag = 'git describe --abbrev=0'
  lastTag = void
  beforeEach !(done) ->
    (err, stdout) <-! exec checkLastTag
    lastTag := stdout.toString!trim!
    done err

  afterEach !(done) ->
    exec "git tag Ver_Si-On--#{ lastTag }_WTf_is_tHIs --delete", done
    lastTag := void

  it 'should work with custom tag name' !(done) ->
    const stream = tag name: 'Ver_Si-On--<%= package.version %>_WTf_is_tHIs'
    stream.on 'data' !->
      (err, stdout) <- exec checkLastTag
      "Ver_Si-On--#{ lastTag }_WTf_is_tHIs".should.equal stdout.toString!trim!
      done err
    
    gulp.src 'package.json' .pipe stream
