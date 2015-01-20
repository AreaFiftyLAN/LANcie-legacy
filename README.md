## Installation of LANcie repo



Prep install + path
-----

- [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git) - Als je dit nog niet geinstalleerd hebt...
- [Node.js](http://nodejs.org/download/) - Kies de juiste versie en installeren
- [Python](https://www.python.org/downloads/) - Voor het runnen van de server heb je version 2.7.0 of hoger nodig
- [Ruby 2.7](https://www.ruby-lang.org/en/documentation/installation/) - Is nodig voor het installeren en compilen van Sass.
- [Sass](http://sass-lang.com/install) - `gem install sass` or `gem source -a http://rubygems.org/ && gem install sass`
- [Gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md) - [requires nodejs] `npm install -g gulp`
- [Bower](http://bower.io/#install-bower) - [requires nodejs] `npm install -g bower`

Cloning and first time serve
-----
```
git clone git@github.com:WISVCH/LANcie.git  
cd LANcie

npm install   
bower install  

gulp serve 
```

#### Local server
```
gulp serve 
```

#### Know Errors + solution

1. Readable-stream error:  
  `npm install --save readable-stream`

2. SyntaxError: missing } after function body on FF [pull requests aangevraagd]
  ```
  open core-layout-trbl.html
  [rgl 157] change <body> to body
  
  open core-dropdown.html
  [rgl 109] change <html> to html
  [rgl 111] change <body> to body
  ```

  
