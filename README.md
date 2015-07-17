# Meteor + Dredd

[Dredd](https://github.com/apiaryio/dredd) is a HTTP API Testing Framework, that
automatically tests your [API Blueprints](https://github.com/apiaryio/api-blueprint) against the backend implementation.
Now, if you write that backend implementation with [Meteor](https://meteor.com),
this package integrates Dredd into Meteor's testing suite
[Velocity](http://velocity.meteor.com) and makes testing your API endpoints with
Dredd as easy as possible.

## Installation

You can test packages only with meteor-dredd. To do so add
`api.use('storeness:meteor-dredd')` to your `package.js` file. This is a
complete example of how your `package.js` might look like


``` javascript
Package.describe({...})
Package.onUse(function(api) { ... })

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('yourname:your-package');
  api.use('storeness:meteor-dredd');

  api.addFiles([
    'tests/dredd/hooks/commonHooks.js'
    'tests/dredd/hooks/specialHooks.js'
    'tests/dredd/blueprints/anotherBlueprint.apib'
  ], 'server', {isAsset: true})
})
```

## Basic Usage

Write your blueprint file just as you would anyways. Now, create the common
directory structure `tests/dredd/blueprints/` and `tests/dredd/hooks/`. Inside
those directories  you can place custom API blueprints and hooks, that dredd will use.

To make dredd use your blueprints and automatically rerun tests, when the
blueprint changes, you might one to create a symlink:

``` shell
ln -s apiary.apib packages/your-package/tests/dredd/blueprints/
```

To run the tests and display them with Velocity run something like this on your
command line

```
VELOCITY_TEST_PACKAGES=1 meteor --port 4000 test-packages --driver-package velocity:html-reporter yourname:your-package
```

