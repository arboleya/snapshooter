require('source-map-support').install()

fs = require 'fs'
path = require 'path'
colors = require 'colors'
exec = (require 'child_process').exec
fsu = require 'fs-util'

Shoot = require './core/shoot'
Cli = require './cli'

module.exports = class Snapshooter

  constructor:->

    # evaluates version and intialize @cli class
    @version = (require './../package.json' ).version
    @cli = new Cli @version

    # shows version
    if @cli.argv.version
      return console.log @version

    # if user has set some input
    if @cli.argv.input

      # check if phantomjs is ok and initialize
      return @check_phantom => do @init

    # if execution reach here, just show help screen
    console.log @cli.opts.help() + @cli.examples


  # initialize crawling party
  init:()->
    # if output folder is not specified (and -O option is also not informed)
    unless @cli.argv.output or @cli.argv.stdout
      console.log '• ERROR '.bold.red + 'Output dir not informed!'
      console.log ' ➜  Alternatively, you can pass -S to write to stdout.'.cyan
      return

    # otherwise if it is but it already exist on disk
    if fs.existsSync @cli.argv.output

      # if --delete options was given
      if @cli.argv.delete?
        # delete folder and proceed
        fsu.rm_rf @cli.argv.output
        do @shoot

      # if --overwrite option was given
      else if @cli.argv.overwrite?

        # just proceed
        do @shoot

      # if none, ask user
      else

        msg = """Output folder exists:
          [O]verwrite existent files
          [D]elete folder before writing new files
          [A]bort

        Enter option
        """

        @prompt msg, /(o|d|a)/i, 'A', (answer)=> 
          answer = do answer.toLowerCase

          # completely delete folder before crawling
          if answer.toLowerCase() is 'd'
            fsu.rm_rf @cli.argv.output
            do @shoot

          # start to crawl overwriting files one by one
          else if answer.toLowerCase() is 'o'
            do @shoot

          # otherwise abort execution
          else
            do process.exit

    # if output folder is informed and it does not exist on disk, go ahead
    else
     do @shoot


  # starting shooting people, bang bang!
  shoot:->
    new Shoot @, @cli


  # checks if system has the right version of phantomjs installed
  check_phantom:( fn )->
    @has_phantom ( status )->
      # and if not
      if status is false

        # raise an alert to install it
        msg = ('• ERROR'.bold + ' First you must to install ').red
        msg += 'phantomjs v1.9.0'.yellow + ' or greater '.red
        msg += '\n\t➜  http://phantomjs.org'.cyan

        console.error msg
        return do process.exit

      do fn


  # evaluates if phantomjs 1.9.x is installed
  has_phantom:( fn )->
    exec "phantomjs -v", (error, stdout, stderr) =>
      fn (/1\.9\.[0-9]+/.test stdout)


 # simple node prompt
  prompt:(question, format, _default, fn)->
    stdin = process.stdin
    stdout = process.stdout

    if _default?
      question += " [#{_default}]"

    stdout.write "#{question}: "

    stdin.once( 'data', (data)=> 
      data = data.toString().trim() or _default
      if format.test data
        fn data.trim()
      else
        msg = "#{'Invalid entry, it should match:'.red}"
        rule = "#{format.toString().cyan}"
        stdout.write "\t#{msg} #{rule}\n"
        @prompt question, format, fn

    ).resume()