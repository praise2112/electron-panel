const { Application } = require('spectron');
const assert = require('assert');
const electronPath = require('electron'); // Require Electron from the binaries included in node_modules.
const path = require('path');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');

global.before(function () {
  chai.should();
  chai.use(chaiAsPromised);
});

describe('Electron Panel', function () {
  this.timeout(10000);

  describe('When `show` enabled in options', function () {

    beforeEach(function () {
      this.app = new Application({
        path: electronPath,
        args: [path.join(__dirname, 'app0')],
        requireName: 'electronRequire',
      });
      return this.app.start();
    });



    afterEach(function () {
      if (this.app && this.app.isRunning()) {
        return this.app.stop();
      }
    });
    // const timeout = (ms) => new Promise((resolve) => setTimeout(resolve, ms));


    it('shows panel', async function () {
      const count = await this.app.client.getWindowCount()
      // await timeout(1000000)
      return count === 1
    });
  });

  describe('#show', function () {

    beforeEach(function () {
      this.app = new Application({
        path: electronPath,
        args: [path.join(__dirname, 'app1')],
        requireName: 'electronRequire',
      });
      return this.app.start();
    });

    afterEach(function () {
      if (this.app && this.app.isRunning()) {
        return this.app.stop();
      }
    });

    it('shows panel', async function () {
      const count = await this.app.client.getWindowCount()
      return count === 1
    });
  });

  describe('#show with animation enabled', function () {

    beforeEach(function () {
      this.app = new Application({
        path: electronPath,
        args: [path.join(__dirname, 'app2')],
        requireName: 'electronRequire',
      });
      return this.app.start();
    });

    afterEach(function () {
      if (this.app && this.app.isRunning()) {
        return this.app.stop();
      }
    });

    it('shows panel', async function () {
      const count = await this.app.client.getWindowCount()
      return count === 1
    });
  });

  describe('#close', function () {

    beforeEach(function () {
      this.app = new Application({
        path: electronPath,
        args: [path.join(__dirname, 'app3')],
        requireName: 'electronRequire',
      });
      return this.app.start();
    });

    afterEach(function () {
      if (this.app && this.app.isRunning()) {
        return this.app.stop();
      }
    });

    it('shows panel', async function () {
      const count = await this.app.client.getWindowCount()
      return count === 1
    });
  });

  describe('#close with animation enabled', function () {

    beforeEach(function () {
      this.app = new Application({
        path: electronPath,
        args: [path.join(__dirname, 'app3')],
        requireName: 'electronRequire',
      });
      return this.app.start();
    });

    afterEach(function () {
      if (this.app && this.app.isRunning()) {
        return this.app.stop();
      }
    });

    it('shows panel', async function () {
      const count = await this.app.client.getWindowCount()
      return count === 1
    });
  });
});
