#<< snapshooter/shoot

exports.run = ->
  new snapshooter.Snapshooter

class snapshooter.Snapshooter

  fs     = require "fs"
  path   = require "path"
  colors = require 'colors'
  
  constructor:->
    @root     = path.normalize __dirname + "/.."

    @version = (require "#{@root}/package.json" ).version

    @usage = "#{'Snapshooter'.bold} " + "v#{@version}\n".grey

    @usage += "#{'Usage:'.bold}\n"
    @usage += "  snapshoot #{'url'.red} #{'render_path'.yellow}    \n\n"

    @usage += "#{'Options:'.bold}\n"
    @usage += "            #{'help'.red}   Show this help screen.\n"

    # grab options starting from index 2
    options = process.argv.slice 2

    # defaults to help command in case user doesn't pass any parameter
    if not options.length
      console.log "ERROR".bold.red + " You should provide an http url to be shooted.\n\n"

    if not options.length or options[0] == 'help'
      console.log @usage

      return

    options[1]     = options[1] || 'static'

    @target_folder = path.resolve options[1]

    new snapshooter.Shoot @, options