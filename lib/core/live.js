// Generated by CoffeeScript 1.6.3
(function() {
  var Crawler, Live, http,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  http = require('http');

  Crawler = require('./crawler');

  /*
    Http proxy for crawling live
  */


  module.exports = Live = (function() {
    function Live(the, cli) {
      var server;
      this.the = the;
      this.cli = cli;
      this.request = __bind(this.request, this);
      new Crawler(null, null, null, true);
      server = http.createServer(this.request);
      server.listen(this.cli.argv.port);
    }

    Live.prototype.request = function(req, res) {
      var _this = this;
      console.time('crawler');
      res.writeHead(200, {
        'Content-Type': 'text/html'
      });
      if (/\./.test(req.url)) {
        return res.end();
      }
      return new Crawler(this.cli, this.cli.argv.input + req.url, function(source) {
        res.end(source);
        return console.timeEnd('crawler');
      });
    };

    return Live;

  })();

}).call(this);

/*
//@ sourceMappingURL=live.map
*/