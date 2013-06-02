fs   = require 'fs'
exec = (require 'child_process').exec
path = require 'path'
fsu  = require 'fs-util'
connect  = require 'connect'

Crawler = require './crawler'

###
  Instantiate a crawler for the first url,
  Crawler returns a source and "<a href=''>" links url

  The links url are filtered ( i.e. external links are not crawled ),
  and then written to disk
###
module.exports = class Shoot

  # Dictionary (url -> true|false)
  crawled: {}

  # root address to be crawled
  root_url: null

  # array of pending_urls urls to crawl
  pending_urls: null

  # current number connections
  connections: 0

  # max number of connections
  max_connections: 10

  # start time for contabilization
  start_time: null


  constructor:( @the, @cli )->

    # checking if user has phantomjs installed
    unless @has_phantom()
      msg = """
        #{'Error'.bold.red} Install #{'phantomjs'.yellow} before indexing pages!
          • http://phantomjs.org
      """
      console.log msg
      process.exit code = process.ENOENT

    # initializes array
    @pending_urls = []

    # if address was specified
    if @cli.argv.address

      # checks if it has http protocol defined, and if not define it
      # and save in @root_url
      unless ~@cli.argv.address.indexOf 'http'
        first_url = 'http://' + @cli.argv.address

        # cleaning anything else after the domain
        @root_url = (first_url.match /https?:\/\/[^\/]+/)[0]

    # otherwise set file as @root_url
    else
      @root_url = first_url = @cli.argv.file
    
    @start_time = do (new Date).getTime
    @crawl first_url


  # crawl the given url and recursively crawl all the links found within
  crawl:( url )->
    return if @crawled[url] is true
    @crawled[url] = false

    console.log '>'.bold.yellow, url.grey 
    @connections++
    new Crawler @cli, url, ( source )=> 
      console.log '< '.bold.cyan, url.grey
      @connections--
      @crawled[url] = true
      if source?
        @save_page url, source
        @after_crawl source


  # parses all links in the given source, and crawl them
  after_crawl:( source )->
    reg = /<a\s+href\s*=\s*["']+(?!http)([^"']+)/g
    links = []

    # filters all links
    if source?
      while (match = reg.exec source)?
        relative = match[1]
        absolute = @root_url + relative
        if relative isnt '/' and not @crawled[absolute]? and relative isnt '#'
          @pending_urls.push absolute

    # starting cralwing them until max_connections is reached
    while @connections < @max_connections and @pending_urls.length
      @crawl do @pending_urls.shift

    if @connections is 0
      do @finish


  # translates the url into a local address on the file system and saves
  # the page source
  save_page:( url, source )->
    # computes relative url
    relative_url = (url.replace @root_url, '') or '/'

    # computes output folder and file
    output_folder = path.join @cli.argv.output, relative_url
    output_file = path.join output_folder, 'index.html'

    # create folder if needed
    unless fs.existsSync output_folder
      fsu.mkdir_p output_folder
    
    # write file to disk and show status msg
    fs.writeFileSync output_file, source
    console.log '✓ '.green, relative_url


  finish:->
    # success status msg
    ms = do (new Date).getTime - @start_time
    console.log "\n★  Application crawled successfully in #{ms}ms!".green

    # aborts if webserver isn't needed
    return unless @cli.argv.server

    # simple static server with 'connect'
    @conn = connect()
    .use( connect.static @cli.argv.output )
    .listen @cli.argv.port

    # webserver start msg
    address = 'http://localhost:' + @cli.argv.port
    console.log '\nPreview server started at: \n\t'.grey, address

  # checks if system has phantomjs installed
  has_phantom:->
    exec "phantomjs -v", (error, stdout, stderr) =>
      return /phantomjs: command not found/.test stderr