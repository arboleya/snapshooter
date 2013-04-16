fs   = require "fs"
exec = (require "child_process").exec
path = require "path"
fsu  = require "fs-util"

Crawler = require './crawler'

###
  Scans a initial address for links, then recursively loads all the
  urls waits it js to render and then write it to a file
###
module.exports = class Shoot

  #
  # key -> value ( address -> is_crawled )
  #
  pages: {}

  #
  # root address to be crawled
  #
  url: null

  #
  # max number of connections
  #
  max_connections: 10

  #
  # current connections
  #
  connections: 0

  #
  #
  #
  crawlers: []

  constructor:( @the, @options )->

    @url = options[0]

    exec "phantomjs -v", (error, stdout, stderr)=>
      if /phantomjs: command not found/.test stderr
        console.log "Error ".bold.red + "Install #{'phantomjs'.yellow}"+
              " before indexing pages."+
              "\n\thttp://phantomjs.org/"
      else
        console.log " - initializing..."
        console.log " #{'>'.yellow} " + @url.grey
        @get @url


  get:( url )->

    crawler = new Crawler()

    @connections++

    @crawlers.push crawler

    @pages[url] = is_crawled: true

    crawler.get_url url, ( src, links ) => 

      @after_render( url, src, links )

      crawler.exit()

      crawler = null

  after_render:(url, src, links)->

    #
    # IF source is null
    #   - mark crawled and continue 
    # ELSE
    #   - get links and save pages
    #
    if src

      @index_links url, links

      @save_page url, src

    else

      console.log " ? skipping, source is empty or null or some problem occured #{url}"

    @connections--

    # crawl next pages
    for url, crawled of @pages
      continue if @pages[url].is_crawled

      @get url

      break if @connections == @max_connections

    # finishs the script after rendering all pages
    @done() unless @connections > 0
      



  ###
  @param url: String 
  @param links: all links mapped using $( 'a' ).attr( 'href') as filter
  ###
  index_links:( url, links )->

    domain = url.match /^https?\:\/\/([^\/?#]+)(?:[\/?#]|$)/i
    domain = domain[0]

    # filthy workaround
    if domain.substr(-1) == '/'
      len = domain.length
      len--
      domain = domain.substr 0, len

    for index, link of links

      # skip if its external link
      continue if /^http/m.test link

      continue if link == '#'

      url = domain + link

      # skip if it was already crawled
      continue if @pages[url].is_crawled

      continue if url.indexOf( @url ) != 0

      console.log " #{'+'.green} " + (url.replace( @url, '' ) ).grey

      # prepare url to be crawled
      @pages[url] = is_crawled: false


  save_page:( url, src )->

    console.log 'url is', url

    reg = url.match /(?:https?:\/\/)(?:[\w]+)(?:\:)?(?:[0-9]+)(?:\/|$)(.*)/m

    return

    filename = (reg.exec url)[1]

    folder = path.normalize "#{@the.target_folder}/#{filename}"
    fsu.mkdir_p folder unless fs.existsSync( folder )

    src = ((require 'pretty-data').pd.xml src) + "\n"

    file = path.normalize "#{folder}/index.html"
    fs.writeFileSync file, src
    filename = (filename or "/").bold.yellow

    console.log " ! rendered - #{filename.bold.yellow} -> #{folder}"

  done: ->

      console.log " OK - indexed successfully.".bold.green