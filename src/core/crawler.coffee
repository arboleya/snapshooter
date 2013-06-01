phantom = require "node-phantom"
jsdom   = require "jsdom"

###
  Create and instance of phantom
###
module.exports = class Crawler

  ph: null
  page: null

  get_url:( url, done )->

    @ph.exit() if @ph?

    @ph   = null # save instance in order to .exit() later
    @page = null # save page for closing later

    phantom.create ( error, @ph ) =>
      @ph.createPage ( error, @page ) =>
        @page.open url, ( err, status )=>

          console.log " ? skipping, source is empty or null or some problem occured #{url}"

          return done( null ) if status is not 'ok'

          @keep_on_checking url, done

  keep_on_checking:( url, done )->

    @page.evaluate ( -> 
      data =
        rendered: window.crawler.is_rendered
        source  : document.all[0].outerHTML
        links   : window.$.map( $( 'a' ), ( item )-> $( item ).attr 'href' )
    ), ( error, data ) =>

      # sometimes data is null, perhaps when the page is 404 or the DOM 
      # is invalid, or its a jpeg or zip or whatever
      if data is null

        console.error 'got null data'

        return done null

      if data.rendered

        return done data.source, data.links

      setTimeout (=> @keep_on_checking url, done), 10

  exit: ->
    # how to close a page?
    # @page.close()
    @ph.exit()