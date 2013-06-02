# Snapshooter

Simple crawler for Single Page Applications.

> Version 0.1.1

[![Dependency Status](https://gemnasium.com/serpentem/snapshooter.png)](https://gemnasium.com/serpentem/snapshooter)

# About

Snapshooter is basicly a crawler, which will load a URL, wait the javascript to
render, save it as plain HTML file and carry on until all `hrefs` are rendered.

# Issues

Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/snapshooter/issues

# Docs
  - [Requirements](#requirements)
  - [Installing](#installing)
  - [Help](#help)
    - [Integration](#integration)
  - [Contributing](#contributing)

Have fun. :)

<a name="requirements" />
## Requirements

You'll need PhantomJS installed in order to use this library.
 * http://phantomjs.org


<a name="installing" />
## Installing

````bash
npm install -g snapshooter
````

<a name="help" />
## Help

````bash
Options:
  -a, --address  Http address to crawl                            
  -f, --file     Local file to crawl                              
  -o, --output   Output folder to save crawled static files       
  -p, --pretty   Output crawled html files in a pretty fashion way
  -s, --server   Start a server for previewing crawled content    
  --port         Preview server port                                [default: 8080]
  -v, --version  Shows snapshooter version                        
  -h, --help     Shows this help screen                           

Examples:
  snapshooter -a <site.com> -o <local-folder>
  snapshooter -a <site.com> -o <local-folder> -p
  snapshooter -a <site.com> -o <local-folder> -ps [--port 3000]

  snapshooter -f <local-file.html> -o <local-folder>
  snapshooter -f <site.com> -o <local-folder> -p
  snapshooter -f <site.com> -o <local-folder> -ps [--port 3000]
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

# Powered by
 - [CoffeeScript](https://github.com/jashkenas/coffee-script)
 - [PhantomJS-node](https://github.com/sgentle/phantomjs-node)
 - [PhantomJS](http://phantomjs.org)