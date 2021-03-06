// Generated by CoffeeScript 1.6.3
(function() {
  var Cli, Live, Shoot, Snapshooter, colors, exec, fs, fsu, path;

  (require('source-map-support')).install({
    handleUncaughtExceptions: false
  });

  fs = require('fs');

  path = require('path');

  colors = require('colors');

  exec = (require('child_process')).exec;

  fsu = require('fs-util');

  Shoot = require('./core/shoot');

  Live = require('./core/live');

  Cli = require('./cli');

  module.exports = Snapshooter = (function() {
    function Snapshooter() {
      var _this = this;
      this.version = (require('./../package.json')).version;
      this.cli = new Cli(this.version);
      if (this.cli.argv.version) {
        return console.log(this.version);
      }
      if (this.cli.argv.input) {
        return this.check_phantom(function() {
          return _this.init();
        });
      }
      console.log(this.cli.opts.help() + this.cli.examples);
    }

    Snapshooter.prototype.init = function() {
      var msg,
        _this = this;
      if (!/^http/m.test(this.cli.argv.input)) {
        this.cli.argv.input = 'http://' + this.cli.argv.input;
      }
      if (this.cli.argv.live) {
        return new Live(this["this"], this.cli);
      }
      if (!(this.cli.argv.output || this.cli.argv.stdout)) {
        console.log('• ERROR '.bold.red + 'Output dir not informed!');
        console.log(' ➜  Alternatively, you can pass -S to write to stdout.'.cyan);
        return;
      }
      if (fs.existsSync(this.cli.argv.output)) {
        if (this.cli.argv["delete"] != null) {
          fsu.rm_rf(this.cli.argv.output);
          return this.shoot();
        } else if (this.cli.argv.overwrite != null) {
          return this.shoot();
        } else {
          msg = "Output folder exists:\n  [O]verwrite existent files\n  [D]elete folder before writing new files\n  [A]bort\n\nEnter option";
          return this.prompt(msg, /(o|d|a)/i, 'A', function(answer) {
            answer = answer.toLowerCase();
            if (answer.toLowerCase() === 'd') {
              fsu.rm_rf(_this.cli.argv.output);
              return _this.shoot();
            } else if (answer.toLowerCase() === 'o') {
              return _this.shoot();
            } else {
              return process.exit();
            }
          });
        }
      } else {
        return this.shoot();
      }
    };

    Snapshooter.prototype.shoot = function() {
      return new Shoot(this, this.cli);
    };

    Snapshooter.prototype.check_phantom = function(fn) {
      return this.has_phantom(function(status) {
        var msg;
        if (status === false) {
          msg = ('• ERROR'.bold + ' First you must to install ').red;
          msg += 'phantomjs v1.9.0'.yellow + ' or greater '.red;
          msg += '\n\t➜  http://phantomjs.org'.cyan;
          console.error(msg);
          return process.exit();
        }
        return fn();
      });
    };

    Snapshooter.prototype.has_phantom = function(fn) {
      var _this = this;
      return exec("phantomjs -v", function(error, stdout, stderr) {
        return fn(/1\.9\.[0-9]+/.test(stdout));
      });
    };

    Snapshooter.prototype.prompt = function(question, format, _default, fn) {
      var stdin, stdout,
        _this = this;
      stdin = process.stdin;
      stdout = process.stdout;
      if (_default != null) {
        question += " [" + _default + "]";
      }
      stdout.write("" + question + ": ");
      return stdin.once('data', function(data) {
        var msg, rule;
        data = data.toString().trim() || _default;
        if (format.test(data)) {
          return fn(data.trim());
        } else {
          msg = "" + 'Invalid entry, it should match:'.red;
          rule = "" + (format.toString().cyan);
          stdout.write("\t" + msg + " " + rule + "\n");
          return _this.prompt(question, format, fn);
        }
      }).resume();
    };

    return Snapshooter;

  })();

}).call(this);

/*
//@ sourceMappingURL=snapshooter.map
*/
