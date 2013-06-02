require('source-map-support').install()

fs = require 'fs'
path = require 'path'
colors = require 'colors'

fsu = require 'fs-util'

Shoot = require './core/shoot'
Cli = require './cli'

module.exports = class Snapshooter
  
  constructor:->
    @version = (require './../package.json' ).version
    @cli = new Cli @version

    if @cli.argv.version
      return console.log @version

    if @cli.argv.input

      unless @cli.argv.output 
        return console.log '• ERROR '.bold.red + 'Output dir not informed!'

      if fs.existsSync @cli.argv.output
        return @prompt 'Output folder exists, overwite?', /.*/, 'y', (answer)=> 
          if answer.toLowerCase() is 'y'
            fsu.rm_rf @cli.argv.output
            do @init
          else
            console.log 'Aborting..'
            do process.exit
      else
        return do @init

    console.log @cli.opts.help() + @cli.examples

  init:->
    return new Shoot @, @cli

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