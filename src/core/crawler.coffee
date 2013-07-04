phantom = require 'phantom'
pd = (require 'pretty-data').pd

###
  Create and instantiate phantomjs thought phantom
###
module.exports = class Crawler

  ph = null
  port = 12345

  page: null
  start_time: null

  port = 12345
  constructor:( @cli, @url, @done )->
    @start_time = do (new Date).getTime
    @create_phantom => @create_page => do @open_url

  @kill:-> do ph.exit


  create_phantom:( done )->
    return do done if ph?

    # creates a new phantom and page instance
    phantom.create '--load-images=false', ( _ph, err )=>
      if err?
        msg = '• ERROR '.bold.red + 'phantom.create couldn\'t finish for '.red
        msg += @url.yellow
        return @error msg, err
      ph = _ph
      do done
    , 'phantomjs'
    , port++

  create_page:( done )->
    ph.createPage ( @page, err )=>

      if err?
        msg = '• ERROR '.bold.red + 'ph.createPage couldn\'t finish for '.red
        msg += @url.yellow
        return @error msg, err

      # do not activate log messages if user has set stdout option, because
      # there's no sense on showing log messages when crawling to stout
      if @cli.argv.log and not @cli.argv.stdout and not @cli.argv.live
        @page.set 'onConsoleMessage', (msg)=>
          console.log msg

      # if hidden options is not provided
      unless @cli.argv.hidden

        # inject snapshooter variable on window, so crawled apps can make
      # decisions based on that
        @page.set 'onInitialized', =>
          @page.evaluate -> window.snapshooter = true

      do done

  open_url:->
    # open the given url
    @page.open @url, ( status, err )=>
      
      if err?
        msg = '• ERROR '.bold.red + 'page.open couldn\'t finish for '.red
        msg += @url.yellow
        return @error msg, err

      # validates http status and rises an error if somethings is wrong
      if status isnt 'success'
        msg = '• ERROR '.bold.red + ' ' + @url.yellow
        msg += " ended with status = ".red + status.bold
        return @error msg

      # start checking page until it's rendered
      do @keep_on_checking


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

    if @ph? then @ph.exit
    @done null