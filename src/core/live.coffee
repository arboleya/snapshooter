http = require 'http'

Crawler = require './crawler'

###
  Http proxy for crawling live
###
module.exports = class Live

  constructor: ( @the, @cli ) ->

    # just forces the phantom instantiation to improve speed on the first
    # url requested after intialization
    new Crawler null, null, null, true

    # start server
    server = http.createServer @request
    server.listen @cli.argv.port

  # handles server requests
  request:(req, res)=>
    console.time 'crawler'

    res.writeHead 200, {'Content-Type': 'text/html'}

    # ignore any request containing "."
    # this way when the browser try to reach files
    # like app.css or app.js the crawler doesn't try to reach it
    if /\./.test( req.url ) then return do res.end

    new Crawler @cli, @cli.argv.input + req.url, ( source )=> 
      res.end source
      console.timeEnd 'crawler'