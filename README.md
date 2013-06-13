# Snapshooter

Simple crawler for Single Page Applications.

> Version 0.2.8

[![Dependency Status](https://gemnasium.com/serpentem/snapshooter.png)](https://gemnasium.com/serpentem/snapshooter)

# About

Snapshooter will load a URL, wait the javascript to render and save it as plain
HTML.

This will be done recursively until all found links in the start URL is saved.

# Issues

Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/snapshooter/issues

# Docs
  - [Requirements](#requirements)
  - [Installing](#installing)
  - [Help](#help)
    - [Integration](#integration)
  - [Contributing](#contributing)

<a name="requirements" />
## Requirements

You'll need PhantomJS installed (v 1.9 or greater) in order to use this package.
 * http://phantomjs.org


<a name="installing" />
## Installing

````bash
npm install -g snapshooter
````

<a name="help" />
## Help

````bash
Usage:
  snapshooter [options] [params]

Options:
  -i, --input            Input url to crawl                                                
  -o, --output           Output folder to save crawled files                               
  -e, --exclude          Regex pattern for excluding files (pass between quotes)           
  -p, --pretty           Output crawled files in a pretty fashion way                      
  -s, --server           Start a server for previewing crawled content                     
  -P, --port             Preview server port                                                 [default: 8080]
  -f, --forward          Avoid crawling links up to the initial url folder                 
  -t, --timeout          Time limit (in seconds) to wait for a page to render                [default: 15]
  -m, --max-connections  Max connections limit, use with care                                [default: 10]
  -l, --log              Show 'console.log' messages (try disabling it if phantom crashes) 
  -O, --once             Avoid recursivity, crawling only the first given url              
  -S, --stdout           Prints crawled content to stdout (auto-set -O=true -l=false)      
  -V, --verbose          Shows info logs about files skipped                               
  -D, --delete           Automatically delete destination folder before writing new files  
  -X, --overwrite        Automatically overwrite destination folder with new files         
  -H, --hidden           Does't inject the `window.snapshooter=true` on pages being crawled
  -v, --version          Shows snapshooter version                                         
  -h, --help             Shows this help screen  
````

<a name="integration" />
### Integration

A very tiny bit of integration is needed in order for it to effectively wait
until all javascript opterations is done, such as data loadings, template
rendering etc.

Considering you have a **Single Page Application** I bet you have also some
`render` method, and possibly another `in` and `out` too for handling
transitions.

Well, the only matter here is to inform **Snapshooter** that the page has finish
rendering. It's achieved by setting the property `window.crawler.is_rendered`.

````javascript
window.crawler.is_rendered = true
````

Snapshooter will keep waiting for the page until this variable gets `true` and
then the rendered DOM will be saved as a plain html file.


<a name="contributing"/>
## Contributing

Download the repo and have fun, pull requests are more than welcome.

### Setting up

````bash
  git clone git://github.com/serpentem/snapshooter.git
  cd snapshooter
  npm link
````

### Compiling

To build, just run:

````bash
make build
````

During develop you may prefer:

````bash
make watch
````

### Attention

Do not mess with version number.

# Powered by
 - [CoffeeScript](https://github.com/jashkenas/coffee-script)
 - [PhantomJS-node](https://github.com/sgentle/phantomjs-node)
 - [PhantomJS](http://phantomjs.org)