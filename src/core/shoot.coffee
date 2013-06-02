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

  # array of skipped urls
  skipped_urls: {}

  # domain being crawled
  domain: null

  # root folder of the first url
  root_folder: null

  # array of pending_urls urls to crawl
  pending_urls: null

  # current number connections
  connections: 0

  # max number of connections
  max_connections: 10

  # start time for contabilization
  start_time: null

  # ignore regex
  ignore: null

  # counters for statistics
  crawled_files_num: 0
  failed_files_num: 0
  skipped_files_num: 0


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

    # if some ignore pattern was given, format it for reuse later
    if @cli.argv.ignore?
      [all, reg, flags] = /(?:\/)(.+)(?:\/)([mgi]+)$/.exec @cli.argv.ignore
      reg = reg.replace /([\/\?])/g, '\\/$1'
      @ignore = new RegExp reg, flags

    # if address was specified, handle it and set @domain
    if @cli.argv.address

      # checks if it has http protocol defined
      unless ~@cli.argv.address.indexOf 'http'

        # computes first url to be crawled
        first_url = @cli.argv.address = 'http://' + @cli.argv.address

        # clear anything else after the domain
        @domain = (first_url.match /https?:\/\/[^\/]+/)[0]

        # computes root folder for the first url
        @root_folder = first_url

    # otherwise set file as @domain
    else
      # computes first file
      first_url = @cli.argv.file

      # computes domain
      @domain = (@cli.argv.match.match /(.+)\/[\w-_\.]+\.html/)[0]

      # computes root folder
      reg = /https?:\/\/[^\/]+\/(.+)\/[\w-_\.]+\.html/
      @root_folder = (first_url.match reg)[0]

    # saves current time for contabilization
    @start_time = do (new Date).getTime

    # start crawling
    @crawl first_url


  # crawl the given url and recursively crawl all the links found within
  crawl:( url )->
    return unless @crawled[url] is undefined
    @crawled[url] = off

    unless @cli.argv.stdout
      console.log '>'.bold.yellow, url.grey 

    @connections++
    new Crawler @cli, url, ( source )=> 

      unless @cli.argv.stdout
        console.log '< '.bold.cyan, url.grey

      @connections--
      @crawled[url] = on

      if source?
        @crawled_files_num++
      else
        @failed_files_num++


      if @cli.argv.stdout
        console.log source
      else
        @save_page url, source
      
      if @cli.argv.once
        do @finish
      else
        @after_crawl source


  # parses all links in the given source, and crawl them
  after_crawl:( source )->
    reg = /<a\s+href\s*=\s*["']+(?!http)([^"']+)/g
    links = []

    # if source is not null
    if source?

      # filters all links
      while (match = reg.exec source)?

        # computes absolut link path
        relative = match[1]
        absolute = @domain + relative

        # checks if it should be crawled
        passed = @url_is_passing relative, absolute
        if passed

          # and adds it to the pending_urls to be cralwed
          @pending_urls.push absolute

        # Otherwise just skips it.
        else
          # If passed is -1, file was alread crawled.
          # If passed is false, file was skipped according other rules.
          skipped = passed isnt -1

          # files already skipped will not appear as skipped more than once
          skipped and= @skipped_urls[absolute] is undefined

          if skipped
            @skipped_files_num++

          # An info message will be shown if user has set verbose=true
          if skipped and @cli.argv.verbose
            @skipped_urls[absolute] = on
            console.log '• INFO '.bold.cyan + "skipping #{absolute.yellow}".cyan

    # starting cralwing them until max_connections is reached
    while @connections < @max_connections and @pending_urls.length
      @crawl do @pending_urls.shift

    if @connections is 0
      do @finish


  # translates the url into a local address on the file system and saves
  # the page source
  save_page:( url, source )->
    # computes relative url
    relative_url = (url.replace @domain, '') or '/'

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
    unless @cli.argv.stdout
      # success status msg
      ms = (do (new Date).getTime - @start_time) + ' ms'
      console.log "\n★  Application crawled successfully in #{ms.magenta}".green
      console.log '\t Indexed: ' + @crawled_files_num
      console.log '\t Skipped: ' + @skipped_files_num
      console.log '\t Failed: ' + @failed_files_num

    # aborts if webserver isn't needed
    return unless @cli.argv.server

    # simple static server with 'connect'
    @conn = connect()
    .use( connect.static @cli.argv.output )
    .listen @cli.argv.port

    # webserver start msg
    address = 'http://localhost:' + @cli.argv.port
    root = @cli.argv.output
    console.log "\nPreview server started for #{root} at: \n\t".grey, address


  # checks if system has phantomjs installed
  has_phantom:->
    exec "phantomjs -v", (error, stdout, stderr) =>
      return /phantomjs: command not found/.test stderr


  # performing some checks to see if the url should be crawled or not
  url_is_passing:( relative, absolute )->
    not_slash = absolute isnt '/'
    not_crawled = @crawled[absolute] is undefined
    not_anchor = relative isnt '#'
    not_image = not (/\.(jpg|jpeg|gif|png)$/m.test absolute)
    not_zip = not (/\.(zip|tar(\.gz)?)$/m.test absolute )
    not_pdf = not (/\.(pdf)$/m.test absolute )

    if @cli.argv.forward
      not_backwards = (absolute.indexOf @root_folder) is 0
    else
      not_backwards = true

    if @ignore?
      not_ignore = not (@ignore.test absolute)
    else
      not_ignore = true

    flags = [
      not_slash,
      not_crawled,
      not_anchor,
      not_image,
      not_zip,
      not_pdf,
      not_ignore,
      not_backwards
    ]

    passed = true
    for flag in flags
      passed and= flag

    if passed
      return true
    else
      if not_crawled is false
        return -1
      else
        return false