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
      snapshooter -a <site.com> -o <local-folder> -ps [--port 3000]

      snapshooter -f <local-file.html> -o <local-folder>
      snapshooter -f <site.com> -o <local-folder> -p
      snapshooter -f <site.com> -o <local-folder> -ps [--port 3000]

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
      .describe('s', 'Start a server for previewing the cralwed content')
      .describe( 'port', 'Preview server port (default=8080)' )
      .default( 'port', 8080 )

      .alias('v', 'version')
      .describe('v', 'Shows snapshooter version')

      .alias('h', 'help')
      .describe('h', 'Shows this help screen')
    ).argv