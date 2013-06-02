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
      snapshooter -a <site.com> -o <local-folder> -ps [--port 3000] [--port 3000] [--once] [--ignore /\\.exe$/m] [--timeout 20000]

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

      .describe('port', 'Preview server port' )
      .default('port', 8080 )

      .describe('once', 'Avoid recursivity, loading only the first given url')

      .describe('stdout', 'Prints crawled content instead of writing file')

      .describe('ignore', 'Regex patter to ignore')

      .describe('timeout', 'Time limit to wait for a page to render')
      .default('timeout', 15000)

      .alias('v', 'version')
      .describe('v', 'Shows snapshooter version')

      .alias('h', 'help')
      .describe('h', 'Shows this help screen')

    ).argv