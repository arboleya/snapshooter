phantom = require 'phantom'
pd = (require 'pretty-data').pd

###
  Create and instantiate phantomjs thought phantom
###
module.exports = class Crawler

  ph: null
  page: null
  start_time: null

  port = 12345
  constructor:( @cli, @url, @done )->
    @start_time = do (new Date).getTime

    # creates a new phantom and page instance
    phantom.create '--load-images=false', ( @ph, err1 )=>
      if err1?
        msg = '• ERROR '.bold.red + 'phantom.create couldn\'t finish for '.red
        msg += @url.yellow
        return @error msg, err1

      @ph.createPage ( @page, err2 )=>

        if err2?
          msg = '• ERROR '.bold.red + 'ph.create couldn\'t finish for '.red
          msg += @url.yellow
          return @error msg, err2

        # consider also if user has set stdout option, because there's no sense
        # on showing log messages when crawling to stout
        if @cli.argv.log and not @cli.argv.stdout
          @page.set 'onConsoleMessage', (msg)=>
            console.log msg

        # inject snapshooter variable on window, so crawled apps can make
        # decisions based on that
        @page.set 'onInitialized', =>
          @page.evaluate -> window.snapshooter = true

        # open the given url
        @page.open @url, ( status, err3 )=>
          
          if err3?
            msg = '• ERROR '.bold.red + 'page.open couldn\'t finish for '.red
            msg += @url.yellow
            return @error msg, err3

          # validates http status and rises an error if somethings is wrong
          if status isnt 'success'
            msg = '• ERROR '.bold.red + ' ' + @url.yellow
            msg += " ended with status = ".red + status.bold
            return @error msg

          # start checking page until it's rendered
          do @keep_on_checking

    , 'phantomjs'
    , port++


  keep_on_checking:=>

    # tries to evaluate page
    @page.evaluate -> 
      data =
        rendered: window.crawler and window.crawler.is_rendered
        source: document.all[0].outerHTML
    , ( data )=>

      # aborts and schedule a new try in 100ms if `data.rendered` isn't true
      unless data?.rendered
        if (do (new Date).getTime) - @start_time > (@cli.argv.timeout * 1000)
          msg = '• ERROR '.bold.red + @url.yellow
          msg += ' took too long to render, skipping'.red
          return @error msg
        else
          return setTimeout @keep_on_checking, 100
      
      # and finally exit phantom process
      do @ph.exit

      # if users opted for pretty data, format it and return
      if @cli.argv.pretty
        @done (pd.xml data.source)

      # otherwise just return it
      else
        @done (data.source.replace /\n/g, '')

  # general error reporting and premature callback dispatcher
  error:( msg, error )->
    console.error msg
    if error?
      console.error error
    do @ph.exit
    @done null