http = require('http');

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

    console.info 'Server listening on port:', @cli.argv.port

  # handles server requests
  request:(req, res)=>
    start = do time

    now = "#{(new Date).toString()}"
    url = "[#{req.url}]"

    res.writeHead 200, {'Content-Type': 'text/html'}

    # ignore any request containing "."
    # this way when the browser try to reach files
    # like app.css or app.js the crawler doesn't try to reach it
    if /\./.test( req.url )
      status = '[ignored]'
      console.log now, status, url
      return do res.end

    new Crawler @cli, @cli.argv.input + req.url, ( source )=> 
      res.end source
      status = '[success]'
      duration = "★  #{time_span start}"
      console.log now, status, url, duration

  time = ->
    do (new Date).getTime

  time_span = (start)->
    return (do time - start) + 'ms'