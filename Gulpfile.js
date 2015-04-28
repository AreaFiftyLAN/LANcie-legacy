/**
 *
 *  Web Starter Kit
 *  Copyright 2014 Google Inc. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License
 *
 */

'use strict';

// Include Gulp & Tools We'll Use
var gulp = require('gulp');

var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');

var $ = require('gulp-load-plugins')();
var del = require('del');
var runSequence = require('run-sequence');
var browserSync = require('browser-sync');
var pagespeed = require('psi');
var reload = browserSync.reload;

var AUTOPREFIXER_BROWSERS = [
  'ie >= 10',
  'ie_mob >= 10',
  'ff >= 30',
  'chrome >= 34',
  'safari >= 7',
  'opera >= 23',
  'ios >= 7',
  'android >= 4.4',
  'bb >= 10'
];

// Lint JavaScript
gulp.task('js:serve', function () {
  return gulp.src('app/scripts/**/*.js')
    .pipe(gulp.dest('.tmp/lib/scripts/'));
});

// Coffee:serve
gulp.task('coffee:serve', function() {
  return gulp.src([
      "app/**/*.coffee", 
      "lib/**/*.coffee"
    ])
    .pipe(coffee({bare: true})
    .on('error', console.error.bind(console)))
    .pipe(gulp.dest('.tmp/lib/'));
});

gulp.task('sass:app:serve', function() {
  return $.rubySass("app/styles/", { style: 'expanded', container: 'gulp-ruby-sass-app' })
      .on('error', console.error.bind(console))
      .pipe(gulp.dest('.tmp/lib/styles/'));
});

gulp.task('sass:lib:serve', function() {
  return $.rubySass("lib/components/", { style: 'expanded', container: 'gulp-ruby-sass-lib' })
      .on('error', console.error.bind(console))
      .pipe(gulp.dest('.tmp/lib/components'));
});

// Copy lib folders to the .tmp folder
gulp.task('lib:serve', function(){
  return gulp.src([
      'lib/components/**/*.{css,js,html,swf,eot,svg,ttf,woff,otf}*',
      'lib/.bower_components/**/*.{css,js,html,swf,eot,svg,ttf,woff,otf}*',
    ])
    .pipe(gulp.dest('.tmp/lib/components'));
});

// Copy json files into .tmp folder
gulp.task('json:serve', function() {
  return gulp.src([
      'app/json/**/*.json'
    ])
    .pipe(gulp.dest('.tmp/lib/scripts/json'));
});

// Watch Files For Changes & Reload
gulp.task('serve', ['sass:app:serve', 'sass:lib:serve', 'lib:serve', 'json:serve', 'coffee:serve', 'js:serve'], function () {
  browserSync({
    notify: false,
    server: ['.tmp', 'app']
  });

  gulp.watch([
    'app/**/*.html',
    'lib/components/**/*.html'
  ], reload);

  gulp.watch([
    'app/**/*.{scss,css}', 
    'lib/**/*.{scss,css}'
  ], ['sass:app:serve', 'sass:lib:serve', reload]);

  gulp.watch([
    'app/**/*.coffee',
    'lib/**/*.coffee',
  ], ['coffee:serve', reload]);

  gulp.watch(['app/json/**/*.json'],['json:serve', reload]);

  gulp.watch([
    'lib/components/**/*.{css,js,html,swf,eot,svg,ttf,woff,otf}*',
    'lib/.bower_components/**/*.{css,js,html,swf,eot,svg,ttf,woff,otf}*'
  ], ['lib:serve', reload]);
});



















// Optimize Images
gulp.task('images:dist', function () {
  return gulp.src([
      'app/images/**/*'
    ])
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true
    })))
    .pipe(gulp.dest('dist/images'));
});

// Copy All Files At The Root Level (app)
gulp.task('copy', function () {
  return gulp.src([
    'app/*',
    '!app/*.html',
    'node_modules/apache-server-configs/dist/.htaccess'
  ], {
    dot: true
  }).pipe(gulp.dest('dist'));
});

// Copy Web Fonts To Dist
gulp.task('fonts', function () {
  return gulp.src(['app/fonts/**'])
    .pipe(gulp.dest('dist/lib/fonts'));
});

// Scan Your HTML For Assets & Optimize Them
gulp.task('html', function () {
  var assets = $.useref.assets({searchPath: '{.tmp,app}'});

  return gulp.src('app/**/*.html')
    .pipe(assets)
    // Concatenate And Minify JavaScript
    .pipe($.if('*.js', $.uglify({preserveComments: 'some'})))
    // Remove Any Unused CSS
    // Note: If not using the Style Guide, you can delete it from
    // the next line to only include styles your project uses.
    .pipe($.if('*.css', $.uncss({
      html: [
        'app/index.html',
        'app/splashpage.html',
        'app/styleguide.html'
      ],
      // CSS Selectors for UnCSS to ignore
      ignore: [
        /.navdrawer-container.open/,
        /.app-bar.open/
      ]
    })))
    // Concatenate And Minify Styles
    // In case you are still using useref build blocks
    .pipe($.if('*.css', $.csso()))
    .pipe(assets.restore())
    .pipe($.useref())
    // Update Production Style Guide Paths
    .pipe($.replace('components/components.css', 'components/main.min.css'))
    // Output Files
    .pipe(gulp.dest('dist'))
    .pipe($.size({title: 'html'}));
});



// Clean Output Directory
gulp.task('clean', del.bind(null, ['.tmp', 'dist']));

// Build and serve the output from the dist build
gulp.task('serve:dist', function () {
  browserSync({
    notify: false,
    // Run as an https by uncommenting 'https: true'
    // Note: this uses an unsigned certificate which on first access
    //       will present a certificate warning in the browser.
    // https: true,
    server: 'dist'
  });
});

// Build Production Files, the Default Task
gulp.task('default', ['clean'], function (cb) {
  runSequence('styles', ['jshint', 'html', 'lib', 'images', 'fonts', 'copy', 'json', 'coffee'], cb);
});

// Run PageSpeed Insights
// Update `url` below to the public URL for your site
gulp.task('pagespeed', pagespeed.bind(null, {
  // By default, we use the PageSpeed Insights
  // free (no API key) tier. You can use a Google
  // Developer API key if you have one. See
  // http://goo.gl/RkN0vE for info key: 'YOUR_API_KEY'
  url: 'https://areafiftylan.nl/',
  strategy: 'mobile'
}));

// Load custom tasks from the `tasks` directory
try { require('require-dir')('tasks'); } catch (err) {}