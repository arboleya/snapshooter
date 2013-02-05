# Snapshooter #

Simple 'javascript' crawler
> Version 0.1.0

# Issues
Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/snapshooter/issues

# Mailing List
soon(ish) ? 

# About

Snapshooter is basicly a crawler, which will load a URL wait the javascript to render, save it as plain HTML file and carry on until all hrefs are rendered.

# Powered by

 - [Node-phantom](https://github.com/alexscheelmeyer/node-phantom)
 - [CoffeeScript](https://github.com/jashkenas/coffee-script)
 - [CoffeeToaster](https://github.com/serpentem/coffee-toaster)
 - [and others...](https://github.com/snapshooter/coffee-toaster/blob/master/toaster.coffee)

Have fun. :)

# Docs
  - [Installing](#installing)
  - [Usage](#usage)
  - [Contributing](#contributing)

<a name="installing" />
# Installing
----

````bash
npm install -g snapshooter
````

<a name="usage" />
# Usage
----

snapshooter http://your_url folder_to_get_rendered_files

<a name="contributing"/>
# Contributing
----

Download the repo and have fun, pull requests are more than welcome.

````bash
  git clone git://github.com/serpentem/snapshooter.git
  cd snapshooter
  npm link
````