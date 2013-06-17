# Changelog

## 0.2.9 - 12/06/2013
 * Added huge performance improvement to ease the pain out of indexing large
 apps.

## 0.2.8 - 12/06/2013
 * Adding `--hidden` option to avoid injection of `window.snapshooter` variable
 on pages being crawled.

## 0.2.7 - 10/06/2013
 * Adding handy options `--delete` and `--overwrite`
 * Injecting `snapshooter=true` variable on window of pages before crawling to
 let apps make decisions based on this
 * Removing line breaks from saved indexed pages when `--pretty` is not informed

## 0.2.6 - 10/06/2013
 * Adding `--log` option to show page `console.log` calls in terminal while
 crawling pages (useful for debug).

## 0.2.5 - 04/06/2013
 * Excluding `mailto:` links
 * Handling absence of first slash on hrefs

## 0.2.4 - 03/06/2013
 * Automatically set -O to true when using -S to avoid errors
 * Handling validation at startup to consider options -o or -S as mandatory 

## 0.2.3 - 03/06/2013
 * Passing regexes between single/double quotes is now mandatory
 * Changing --timeout to use seconds instead of milliseconds

## 0.2.2 - 02/06/2013
 * Fixing and improving validations at startup one more time
 * Validating specific version of installed phantomjs to reduce problems

## 0.2.1 - 02/06/2013
 * Fixing validations at startup

## 0.2.0 - 02/06/2013
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