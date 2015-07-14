var hooks = require('hooks');

hooks.beforeAll(function (transactions, done) {
  hooks.log('before all');
  done()
});

hooks.beforeEach(function (transaction, done) {
  hooks.log('before each');
  done()
});

hooks.before("Humaidor > Data > Dataset > Create Dataset", function (transaction, done) {
  transaction.skip = true;
  done()
});
