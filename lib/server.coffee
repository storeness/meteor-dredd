DEBUG = !!process.env.VELOCITY_DEBUG

if process.env.NODE_ENV != 'development'
  return

path = Npm.require 'path'
Dredd = Npm.require 'dredd'

FRAMEWORK_NAME = 'dredd'
FRAMEWORK_REGEX = FRAMEWORK_NAME + '/.+\\.(feature|md|apib|js|coffee|litcoffee|coffee\\.md)$'

Velocity?.registerTestingFramework? FRAMEWORK_NAME,
  regex: FRAMEWORK_REGEX
  sampleTestGenerator: ->
    [
      {
        contents: Assets.getText path.join 'lib', 'test-sample', 'hooks', 'testHook.js'
        path: path.join FRAMEWORK_NAME, 'hooks', 'testHook.js'
      }, {
        contents: Assets.getText path.join 'lib', 'test-sample', 'blueprints', 'testBlueprint.apib'
        path: path.join FRAMEWORK_NAME, 'blueprints', 'testBlueprint.apib'
      }
    ]
Meteor.startup ->
  DEBUG && console.log '[dredd] Startup'
  _run()

_run = ->

  DEBUG && console.log '[dredd] Dredd is running'

  Meteor.call 'velocity/reports/reset', { framework: FRAMEWORK_NAME }, (error, msg) ->
    console.error('[dredd] Error reseting reports', error) if error

  dredd = new Dredd
    server: Meteor.absoluteUrl()
    options:
      silent: true
      sorted: true
      path: [
        "**/*/#{FRAMEWORK_NAME}/blueprints/*.apib",
        "**/*/#{FRAMEWORK_NAME}/blueprints/*.md"
      ]
      hookfiles: [
        "**/*/#{FRAMEWORK_NAME}/hooks/*.js"
      ]
    emitter: share.MeteorDreddEmitter

  dredd.run(Meteor.bindEnvironment((error, stats) ->
    DEBUG && console.log '[dredd] error', error
    DEBUG && console.log '[dredd] stats', stats

    Meteor.call 'velocity/reports/completed', { framework: FRAMEWORK_NAME }
  ))

