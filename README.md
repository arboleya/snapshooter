# Snapshooter

Simple 'javascript' crawler.

> Version 0.1.0

# About

Snapshooter is basicly a crawler, which will load a URL, wait the javascript to
render, save it as plain HTML file and carry on until all `hrefs` are rendered.

# Issues

Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/snapshooter/issues

# Docs
  - [Installing](#installing)
  - [Usage](#usage)
    - [Integration](#integration)
  - [Contributing](#contributing)

Have fun. :)

<a name="installing" />
## Installing

````bash
npm install -g snapshooter
````

<a name="usage" />
## Usage

`snapshooter [http://your_url] [output_folder]`

<a name="integration" />
### Integration

A very tiny bit of integration is needed in order for it to effectively wait
until all javascript opterations such as data loadings, template rendering etc.

Considering you have a **Single Page Application** I bet you have also some
`render` method, and possibly another `in` and `out` too for handling transitions.

Well, the only matter here is to inform **Snapshooter** that the page has finish
rendering. It's achieved by setting the property `window.snapshooter.is_rendered`.

````javascript
window.snapshooter.is_rendered = true
````

Snapshooter will keep waiting for the page until this variable gets `true` and
then the rendered DOM will be saved as a plain html file.


<a name="contributing"/>
## Contributing

Download the repo and have fun, pull requests are more than welcome.

````bash
  git clone git://github.com/serpentem/snapshooter.git
  cd snapshooter
  npm link
````

# Powered by
 - [CoffeeScript](https://github.com/jashkenas/coffee-script)
 - [Node-phantom](https://github.com/alexscheelmeyer/node-phantom)
 - [PhantomJS](http://phantomjs.org)