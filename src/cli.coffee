optimist = require 'optimist'

module.exports = class Cli

  constructor:( @version )->
    @usage = "#{'Snapshooter'} " + "v#{@version}\n".grey
    @usage += "Simple crawler for Single Page Applications\n\n".grey

    @usage += "#{'Usage:'}\n"
    @usage += "  snapshooter [#{'options'.green}] [#{'params'.green}]"

    @examples = """\n
    Examples:
      snapshooter -a <site.com> -o <local-folder>
      snapshooter -a <site.com> -o <local-folder> -p
      snapshooter -a <site.com> -o <local-folder> -ps [-P 3000] [-O] [-i /\\.exe$/m] [-T 20000]

    """

    @argv = (@opts = optimist.usage( @usage )

      .alias('a', 'address')
      .describe('a', 'Http address to crawl')

      .alias('f', 'file')
      .describe('f', 'Local file to crawl')

      .alias('o', 'output')
      .describe('o', 'Output folder to save crawled static files')

      .alias('p', 'pretty')
      .describe('p', 'Output crawled html files in a pretty fashion way')

      .alias('s', 'server')
      .describe('s', 'Start a server for previewing crawled content')

      .alias('P', 'port')
      .describe('P', 'Preview server port' )
      .default('P', 8080 )

      .alias('F', 'forward')
      .describe('F', 'Avoid crawling links up to the initial url folder')

      .alias('O', 'once')
      .describe('O', 'Avoid recursivity, loading only the first given url')

      .alias('S', 'stdout')
      .describe('S', 'Prints crawled content instead of writing file')

      .alias('i', 'ignore')
      .describe('i', 'Regex pattern to ignore')

      .alias('t', 'timeout')
      .describe('t', 'Time limit to wait for a page to render')
      .default('t', 15000)

      .alias('V', 'verbose')
      .describe('V', 'Shows info logs about files skipped')

      .alias('v', 'version')
      .describe('v', 'Shows snapshooter version')

      .alias('h', 'help')
      .describe('h', 'Shows this help screen')

    ).argv