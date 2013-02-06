var snapshooter = exports.snapshooter = {};

(function() {

  snapshooter.Crawler = (function() {
    var jsdom, phantom;

    function Crawler() {}

    phantom = require("node-phantom");

    jsdom = require("jsdom");

    Crawler.prototype.page = null;

    Crawler.prototype.get_url = function(url, done) {
      var _this = this;
      if (this.ph != null) {
        this.ph.exit();
      }
      this.ph = null;
      this.page = null;
      return phantom.create(function(error, ph) {
        _this.ph = ph;
        return _this.ph.createPage(function(error, page) {
          _this.page = page;
          return _this.page.open(url, function(err, status) {
            if (status === !'ok') {
              return done(null);
            }
            return _this.keep_on_checking(url, done);
          });
        });
      });
    };

    Crawler.prototype.keep_on_checking = function(url, done) {
      var _this = this;
      return this.page.evaluate((function() {
        var data;
        return data = {
          rendered: window.crawler.is_rendered,
          source: document.all[0].outerHTML
        };
      }), function(error, data) {
        if (data === null) {
          return done(null);
        }
        if (data.rendered) {
          return done(data.source);
        }
        return setTimeout((function() {
          return _this.keep_on_checking(url, done);
        }), 10);
      });
    };

    Crawler.prototype.exit = function() {
      return this.ph.exit();
    };

    return Crawler;

  })();

  /*
    Scans a initial address for links, then recursively loads all the
    urls waits it js to render and then write it to a file
  */


  snapshooter.Shoot = (function() {
    var exec, fs, fsu, path;

    fs = require("fs");

    exec = (require("child_process")).exec;

    path = require("path");

    fsu = require("fs-util");

    Shoot.prototype.pages = {};

    Shoot.prototype.url = null;

    Shoot.prototype.max_connections = 10;

    Shoot.prototype.connections = 0;

    Shoot.prototype.crawlers = [];

    function Shoot(the, options) {
      var _this = this;
      this.the = the;
      this.options = options;
      this.url = options[0];
      exec("phantomjs -v", function(error, stdout, stderr) {
        if (/phantomjs: command not found/.test(stderr)) {
          return console.log("Error ".bold.red + ("Install " + 'phantomjs'.yellow) + " before indexing pages." + "\n\thttp://phantomjs.org/");
        } else {
          console.log(" - initializing...");
          console.log((" " + '>'.yellow + " ") + _this.url.grey);
          return _this.get(_this.url);
        }
      });
    }

    Shoot.prototype.get = function(url) {
      var crawler,
        _this = this;
      crawler = new snapshooter.Crawler();
      this.connections++;
      this.crawlers.push(crawler);
      this.pages[url] = true;
      return crawler.get_url(url, function(src) {
        _this.after_render(url, src);
        crawler.exit();
        return crawler = null;
      });
    };

    Shoot.prototype.after_render = function(url, src) {
      var crawled, _ref;
      if (src) {
        this.parse_links(url, src);
        this.save_page(url, src);
      } else {
        console.log(" ? skipping, source is empty or null or some problem occured " + url);
      }
      this.connections--;
      _ref = this.pages;
      for (url in _ref) {
        crawled = _ref[url];
        if (this.pages[url]) {
          continue;
        }
        this.get(url);
        if (this.connections === this.max_connections) {
          break;
        }
      }
      if (!(this.connections > 0)) {
        return this.done();
      }
    };

    /*
      Parse Source code for giving URL indexing links to be cralwed 
    
      @param url: String 
      @param src: String
    */


    Shoot.prototype.parse_links = function(url, src) {
      var domain, matched, reg, _results;
      domain = url.match(/(http:\/\/[\w]+:?[0-9]*)/g);
      reg = /a\shref=(\"|\')(\/)?([^\'\"]+)/g;
      console.log(" - scanning links - " + url);
      _results = [];
      while ((matched = reg.exec(src)) != null) {
        if (/^http/m.test(matched[3])) {
          continue;
        }
        url = "" + domain + "/" + matched[3];
        if (this.pages[url]) {
          continue;
        }
        if (url.indexOf(this.url) !== 0) {
          continue;
        }
        console.log((" " + '+'.green + " ") + (url.replace(this.url, '')).grey);
        _results.push(this.pages[url] = false);
      }
      return _results;
    };

    Shoot.prototype.save_page = function(url, src) {
      var file, folder, route;
      route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec(url))[5];
      folder = path.normalize("" + this.the.target_folder + "/" + route);
      if (!fs.existsSync(folder)) {
        fsu.mkdir_p(folder);
      }
      src = ((require('pretty-data')).pd.xml(src)) + "\n";
      file = path.normalize("" + folder + "/index.html");
      fs.writeFileSync(file, src);
      route = (route || "/").bold.yellow;
      return console.log(" ! rendered - " + route.bold.yellow + " -> " + folder);
    };

    Shoot.prototype.has_rendered = function(url) {
      var folder, route;
      route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec(url))[5];
      folder = path.normalize("" + this.the.target_folder + route);
      return fs.existsSync(folder);
    };

    Shoot.prototype.done = function() {
      return console.log(" OK - indexed successfully.".bold.green);
    };

    return Shoot;

  })();

  exports.run = function() {
    return new snapshooter.Snapshooter;
  };

  snapshooter.Snapshooter = (function() {
    var colors, fs, path;

    fs = require("fs");

    path = require("path");

    colors = require('colors');

    function Snapshooter() {
      var options;
      this.root = path.normalize(__dirname + "/..");
      this.version = (require("" + this.root + "/package.json")).version;
      this.usage = ("" + 'Snapshooter'.bold + " ") + ("v" + this.version + "\n").grey;
      this.usage += "" + 'Usage:'.bold + "\n";
      this.usage += "  snapshoot " + 'url'.red + " " + 'render_path'.yellow + "    \n\n";
      this.usage += "" + 'Options:'.bold + "\n";
      this.usage += "            " + 'help'.red + "   Show this help screen.\n";
      options = process.argv.slice(2);
      if (!options.length) {
        console.log("ERROR".bold.red + " You should provide an http url to be shooted.\n\n");
      }
      if (!options.length || options[0] === 'help') {
        console.log(this.usage);
        return;
      }
      options[1] = options[1] || 'static';
      this.target_folder = path.resolve(options[1]);
      new snapshooter.Shoot(this, options);
    }

    return Snapshooter;

  })();

}).call(this);
