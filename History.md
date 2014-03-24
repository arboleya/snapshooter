0.3.9 / 2014-03-24
===================
 * Minors

0.3.8 / 2014-03-24
===================
 * Minors

0.3.7 / 2014-03-24
===================
 * Minors

0.3.6 / 2014-03-21
===================
 * Improving performance

0.3.5 / 2013-11-27
===================
 * Fixing package.json

0.3.4 / 2013-11-27
===================
 * Added support for external "before_save:($)" hook through parameter -k
 * Added jquery-node as dependency
 * Updated versions @ package.json

0.3.3 / 2013-08-08
===================
 * Fixing links parser to collect only hrefs that starts with a slash (/...),
 and also ignoring attributes order

0.3.2 / 2013-08-06
===================
 * Fixing protocol's handler (closes #9) 

0.3.1 / 2013-08-05
===================
 * Little improve on docs

0.3.0 / 2013-08-05
===================
 * Adding live mode (option -L)

0.2.15 / 2013-07-30
===================
 * Upgrading dependencies

0.2.14 / 2013-07-24
===================
 * Fixing `phantom.create` signature according `phantom-js-node` API update

0.2.13 / 2013-07-04
===================
 * Properly exiting phantom on page rendering timeout

0.2.12 / 2013-06-30
===================
 * Upgrading outdated dependencies

0.2.11 / 2013-06-30
===================
 * Properly exiting process when no `-s` option is given

0.2.10 / 2013-18-06
===================
 * Fixing validation rule when overwriting existent directory, making [A]bort
 option default in order to avoid disasters.

0.2.9 / 2013-12-06
===================
 * Added huge performance improvement to ease the pain out of indexing large
 apps.

0.2.8 / 2013-12-06
===================
 * Adding `--hidden` option to avoid injection of `window.snapshooter` variable
 on pages being crawled.

0.2.7 / 2013-10-06
===================
 * Adding handy options `--delete` and `--overwrite`
 * Injecting `snapshooter=true` variable on window of pages before crawling to
 let apps make decisions based on this
 * Removing line breaks from saved indexed pages when `--pretty` is not informed

0.2.6 / 2013-10-06
===================
 * Adding `--log` option to show page `console.log` calls in terminal while
 crawling pages (useful for debug).

0.2.5 / 2013-04-06
===================
 * Excluding `mailto:` links
 * Handling absence of first slash on hrefs

0.2.4 / 2013-03-06
===================
 * Automatically set -O to true when using -S to avoid errors
 * Handling validation at startup to consider options -o or -S as mandatory 

0.2.3 / 2013-03-06
===================
 * Passing regexes between single/double quotes is now mandatory
 * Changing --timeout to use seconds instead of milliseconds

0.2.2 / 2013-02-06
===================
 * Fixing and improving validations at startup one more time
 * Validating specific version of installed phantomjs to reduce problems

0.2.1 / 2013-02-06
===================
 * Fixing validations at startup

0.2.0 / 2013-02-06
===================
 * Snapshooter REVAMPED!
 * Switching phantomjs bridge library
 * Fixing and improving url parsers
 * Adding proper CLI helper with flexible options and flags
  * --input
  * --output
  * --exclude
  * --pretty
  * --server
  * --port
  * --forward
  * --timeout
  * --max-connections
  * --once
  * --stdout
  * --verbose
  * --version
  * --help
 * Adding simple static WebServer for previewing crawled content
 * Adding makefile targets for publishing and watching project
 * Publishing pure javasript again in the name of God
 * Adding `source-map-support` to keep error msgs as sane as possible