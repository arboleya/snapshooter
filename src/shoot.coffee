fs   = require "fs"
exec = (require "child_process").exec
path = require "path"
fsu  = require "fs-util"

Crawler = require './crawler'

###
  Instantiate a crawler for the first url,
  Crawler returns a source and "<a href=''>" links url

  The links url are filtered ( i.e. external links are not crawled ),
  and then written to disk
###
module.exports = class Shoot

  # Dictionary ( url -> crawled [ on | off ] )
  pages: {}

  # root address to be crawled
  root_url: null

  # max number of connections
  max_connections: 10

  # current number connections
  connections: 0

  will_need_phantom: () ->
    exec "phantomjs -v", (error, stdout, stderr) =>
      if /phantomjs: command not found/.test stderr
        console.log "Error ".bold.red + "Install #{'phantomjs'.yellow}"+
              " before indexing pages."+
              "\n\thttp://phantomjs.org/"

        process.exit code = process.ENOENT

  constructor: ( @the, @options ) ->

    this.will_need_phantom()

    @root_url = options[0]

    console.log " - initializing..."
    console.log " #{'>'.yellow} " + @root_url.grey

    @crawl @root_url



  # API


  crawl: ( url ) ->

    @connections++

    @mark_as_crawled url

    crawler = new Crawler()

    crawler.get_url url, ( source, links ) => 

      @after_parse url, source, links

      crawler.exit()

      crawler = null

  after_parse: ( url, source, links ) ->

    #
    # IF source is null
    #   - mark crawled and continue 
    # ELSE
    #   - get links and save pages
    #
    if source

      @index_links url, links

      filename = url.replace @root_url, ''

      @save_page filename, source


    @connections--

    #
    # crawl next pages
    # 
    for url, crawled of @pages
      continue if @already_crawled url

      @crawl url

      break if @reached_connection_limit()

    # finishs the script after rendering all pages
    @done() unless @still_has_connections()
      



  ###
  @param url: String 
  @param links: all links mapped using $( 'a' ).attr( 'href') as filter
  ###
  index_links:( url, links ) =>

    domain = url.match /^https?\:\/\/([^\/?#]+)(?:[\/?#]|$)/i
    domain = domain[0]

    # filthy workaround
    if domain.substr(-1) == '/'
      len = domain.length
      len--
      domain = domain.substr 0, len

    if domain.substr(0) == '/'
      domain = domain.substr(1)

    for index, link of links

      continue if link == '#'

      url = domain + link

      # skip if it was already crawled
      continue if @already_crawled url

      continue if @is_external_link url

      console.log " #{'+'.green} " + (url.replace( @root_url, '' ) ).grey

      # prepare url to be crawled
      @add_to_index url


  ###
  TODO: expose with "live coffee config file"
  ###
  save_page:( filename, src )->

    # console.log 'url is', url
    # console.log '@root_url is', @root_url
    # console.log 'filename is', filename

    # create folder if needed
    folder = path.normalize "#{@the.target_folder}/#{filename}"
    fsu.mkdir_p folder unless fs.existsSync( folder )

    # prettify source
    src = ((require 'pretty-data').pd.xml src) + "\n"

    # write file to disk
    file = path.normalize "#{folder}/index.html"
    fs.writeFileSync file, src


    filename = (filename or "/").bold.yellow

    console.log " ! rendered - #{filename.bold.yellow} -> #{folder}"

  ###
  TODO: expose with "live coffee config file"
  ###
  done: ->

      console.log " OK - indexed successfully.".bold.green

      process.exit code = 0


  add_to_index   : ( url ) -> @pages[url] = is_crawled: false

  mark_as_crawled: ( url ) -> @pages[url] = crawled: on

  already_crawled: ( url ) -> @pages[url]?.crawled is on

  # check if url contains "root" url
  is_external_link: ( url ) -> url.indexOf( @root_url ) != 0

  reached_connection_limit: -> @connections == @max_connections

  still_has_connections:    -> @connections > 0
