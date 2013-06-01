phantom = require 'phantom'
pd = (require 'pretty-data').pd

###
  Create and instance of phantom
###
module.exports = class Crawler

  ph: null
  page: null

  port = 12345

  constructor:( @cli, @url, @done )->

    # creates a new phantom and page instance
    phantom.create ( @ph, err1 )=>
      console.error 'err1', err1 if err1?

      @ph.createPage ( @page, err2 )=>
        console.error 'err1', err2 if err2?

        # open the given url
        @page.open @url, ( status )=>
            
          # validates http status and rises an error if somethings is wrong
          if status isnt 'success'
            console.error @url, 'ended with status = ' + status

          # start checking page until it's rendered
          do @keep_on_checking

    , 'phantomjs'
    , port++


  keep_on_checking:=>

    # tries to evaluate page
    @page.evaluate -> 
      data =
        rendered: window.crawler and window.crawler.is_rendered
        source  : document.all[0].outerHTML
    , ( data, error )=>

      # aborts and shecule a new try in 10ms if `data.rendered` isn't true
      unless data?.rendered
        return setTimeout @keep_on_checking, 10
      
      # and finally exist phantom process
      do @ph.exit

      # if users opted for pretty data, format it and return
      if @cli.argv.pretty
        @done (pd.xml data.source)

      # otherwise just return it
      else
        @done data.source
