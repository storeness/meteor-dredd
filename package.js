Package.describe({
  name: 'storeness:meteor-dredd',
  version: '0.9.6',
  summary: 'API Testing framework Dredd for Velocity',
  git: 'https://github.com/storeness/meteor-dredd',
  documentation: 'README.md',
  debugOnly: true
});

Npm.depends({
  'dredd' : '1.0.0',
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use('coffeescript');

  api.use([
    'underscore@1.0.2',
    'velocity:core@0.6.4',
    'velocity:shim@0.1.0'
  ], ['server', 'client']);

  api.use([
    'velocity:html-reporter@0.5.3'
  ], 'client');

  api.add_files([
    'lib/test-sample/hooks/testHook.js',
    'lib/test-sample/blueprints/testBlueprint.apib'
  ], 'server', {isAsset: true});

  api.addFiles([
    'lib/emitter.coffee',
    'lib/server.coffee'
  ], 'server');
});
