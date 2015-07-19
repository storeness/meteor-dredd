EventEmitter = Npm.require('events').EventEmitter

FRAMEWORK_NAME = 'dredd'

_getBaseResult = (test) ->
  _getResult = (test) ->
    switch test.status
      when 'skip' then 'pending'
      when 'fail' then 'failed'
      when 'pass' then 'passed'
      else 'failed'

  {
    id: "#{FRAMEWORK_NAME}:#{test.origin.apiName}:#{test.origin.resourceGroupName}:#{test.origin.resourceName}:#{test.origin.actionName}:#{test.origin.exampleName}"
    async: true
    framework: FRAMEWORK_NAME
    name: "#{test.origin.resourceGroupName} > #{test.origin.resourceName} > #{test.origin.actionName}#{if test.origin.exampleName then " > #{test.origin.exampleName}" else ""}"
    pending: _getResult(test) is 'pending'
    result: _getResult(test)
    duration: new Date() - test.startedAt
    ancestor: [test.origin.resourceName, test.origin.resourceGroupName, test.origin.apiName]
    isServer: Meteor.isServer
    isClient: Meteor.isClient
    timestamp: new Date()
  }

share.MeteorDreddEmitter = new EventEmitter()

share.MeteorDreddEmitter.on 'start', (rawBlueprint, callback) =>
  callback()

share.MeteorDreddEmitter.on 'end', (callback) =>
  callback()

share.MeteorDreddEmitter.on 'test start', (test) =>

share.MeteorDreddEmitter.on 'test pass', Meteor.bindEnvironment((test) =>
  t_result = _getBaseResult test
  Meteor.call 'velocity/reports/submit', t_result
)

share.MeteorDreddEmitter.on 'test skip', Meteor.bindEnvironment((test) =>
  t_result = _getBaseResult test
  Meteor.call 'velocity/reports/submit', t_result
)

share.MeteorDreddEmitter.on 'test fail', Meteor.bindEnvironment((test) =>
  t_result = _getBaseResult test
  t_result.failureMessage = test.message
  t_result.failureStackTrace = """
    EXPECTED
    #{prettyPrint test.expected}

    ACTUAL
    #{prettyPrint test.actual}

    REQUEST
    #{prettyPrint test.request}

    RESULT
    #{prettyPrint test.results}
  """
  Meteor.call 'velocity/reports/submit', t_result
)

share.MeteorDreddEmitter.on 'test error', Meteor.bindEnvironment((error, test) =>
  t_result = _getBaseResult test
  t_result.failureMessage = error.message
  t_result.failureStackTrace = error.stack

  Meteor.call 'velocity/reports/submit', t_result
)

prettyPrint = (obj, indent) ->
  result = ''
  indent = '  ' if indent is null or indent is undefined

  for property of obj
    value = obj[property]
    if typeof value == 'string'
      value = '\'' + value + '\''
    else if typeof value == 'object'
      if value instanceof Array
        # Just let JS convert the Array to a string!
        value = '[ ' + value + ' ]'
      else
        od = prettyPrint(value, indent + '  ')
        value = '\n' + indent + '{\n' + od + '\n' + indent + '}'
    result += indent + '\'' + property + '\' : ' + value + ',\n'

  result.replace /,\n$/, ""
