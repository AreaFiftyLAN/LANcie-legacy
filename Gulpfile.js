var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    rename = require('gulp-rename'),
    watch = require('gulp-watch'),
    notify = require('gulp-notify');

gulp.task('express', function() {
  var express = require('express');
  var app = express();
  app.use(require('connect-livereload')({port: 4002}));
  app.use(express.static(__dirname));
  app.listen(4000);
});

var tinylr;
gulp.task('livereload', function() {
  tinylr = require('tiny-lr')();
  tinylr.listen(4002);
});

gulp.task('sass', function () {
  gulp.src('common/styles/**/*.scss')
  .pipe(sass({ 
    noCache: true,
    style: "expanded",
    lineNumbers: true,
    loadPath: 'common/styles/main.scss'
  }))
  .pipe(gulp.dest('.tmp/common/css/'));
});

gulp.task('watch', function() {
  // watch scss files
  gulp.watch('common/styles/**/*.scss', function() {
    gulp.run('sass');
  });
});

gulp.task('default', ['sass', 'express', 'livereload', 'watch']);