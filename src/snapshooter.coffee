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

    if @cli.argv.input
      
      if fs.existsSync @cli.argv.output
        return @prompt 'Output folder exists, overwite?', /.*/, 'y', (answer)=> 
          if answer.toLowerCase() is 'y'
            fsu.rm_rf @cli.argv.output
            @init()
          else
            console.log 'Aborting..'
            do process.exit
      else
        console.log '• ERROR '.bold + 'Output dir not informed!'.red

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