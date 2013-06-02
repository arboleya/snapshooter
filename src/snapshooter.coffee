require('source-map-support').install()

fs = require 'fs'
path = require 'path'
colors = require 'colors'

Shoot = require './core/shoot'
Cli = require './cli'

module.exports = class Snapshooter
  
  constructor:->
    @version = (require './../package.json' ).version
    @cli = new Cli @version

    if @cli.argv.input
      return new Shoot @, @cli

    console.log @cli.opts.help() + @cli.examples