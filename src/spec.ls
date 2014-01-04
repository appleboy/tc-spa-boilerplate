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

const {commit, tag, push, publish} = gulp-release

describe 'commit' !(...) ->
  const checkLastParent = "git rev-list --parents --max-count=1 master | grep "

  it 'should work with default options' !(done) ->
    const stream = commit!
    stream.on 'data' !->
      (err, stdout) <- exec "#{ checkLastParent }#{ lastCommit }"
      should.exist stdout.toString!trim!
      done err
    
    gulp.src 'package.json' .pipe stream
    