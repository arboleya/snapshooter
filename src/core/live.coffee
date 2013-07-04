http = require('http');

Crawler = require './crawler'

###
  Http proxy for crawling live
###
module.exports = class Live


  constructor: ( @the, @cli ) ->
    server = http.createServer (req, res) =>

      res.writeHead 200, {'Content-Type': 'text/html'}

      # ignore any request containing "."
      # this way when the browser try to reach files
      # like app.css or app.js the crawler doesn't try to reach it
      if /\./.test( req.url ) then return res.end()

      console.warn 'trying to catch', ( @cli.argv.input + req.url )

      new Crawler @cli, @cli.argv.input + req.url, ( source )=> 

        res.end source

    server.listen @cli.argv.port