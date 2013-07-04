optimist = require 'optimist'

module.exports = class Cli

  constructor:( @version )->
    @usage = "#{'Snapshooter'} " + "v#{@version}\n".grey
    @usage += "Simple crawler for Single Page Applications\n\n".grey

    @usage += "#{'Usage:'}\n"
    @usage += "  snapshooter [#{'options'.green}] [#{'params'.green}]"

    @examples = """\n
    Examples:
      snapshooter -i <site.com> -o <local-folder>
      snapshooter -i <site.com> -o <local-folder> -p
      snapshooter -i <site.com> -o <local-folder> -ps [-P 3000] [-e '/\\.exe$/m'] [-t 20000]

    """

    @argv = (@opts = optimist.usage( @usage )

      .alias('i', 'input')
      .describe('i', 'Input url to index')

      .alias('o', 'output')
      .describe('o', 'Output folder to save indexed files')

      .alias('e', 'exclude')
      .describe('e', 'Regex pattern for excluding files (pass between quotes)')

      .alias('p', 'pretty')
      .describe('p', 'Output indexed files in a pretty fashion way')

      .alias('s', 'server')
      .describe('s', 'Start a server for previewing indexed content')

      .alias('P', 'port')
      .describe('P', 'Preview server port' )
      .default('P', 8080 )

      .alias('f', 'forward')
      .describe('f', 'Avoid indexing links up to the initial url folder')

      .alias('t', 'timeout')
      .describe('t', 'Time limit (in seconds) to wait for a page to render')
      .default('t', 15)

      .alias('m', 'max-connections')
      .describe('m', 'Max connections limit, use with care')
      .default('m', 10)

      .alias('l', 'log')
      .describe('l', 'Show \'console.log\' messages (try disabling it if phantom crashes)')

      .alias('L', 'live')
      .describe('L', 'creates a "live" tunnel, crawling will happen on demand ')

      .alias('O', 'once')
      .describe('O', 'Avoid recursivity, index only the given url and nothing else')

      .alias('S', 'stdout')
      .describe('S', 'Prints indexed content to stdout (auto-set -O=true -l=false)')

      .alias('V', 'verbose')
      .describe('V', 'Shows info logs about files skipped')

      .alias('D', 'delete')
      .describe( 'D', 'Automatically delete destination folder before writing new files')
      
      .alias('X', 'overwrite')
      .describe('X', 'Automatically overwrite destination folder with new files')

      .alias('H', 'hidden')
      .describe('H', 'Doesn\'t inject the `window.snapshooter=true` on pages being indexed')

      .alias('v', 'version')
      .describe('v', 'Shows snapshooter version')

      .alias('h', 'help')
      .describe('h', 'Shows this help screen')

    ).argv