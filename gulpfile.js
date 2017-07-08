var gulp = require('gulp');
var sourcemaps = require('gulp-sourcemaps');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var coffee = require('gulp-coffee');
var babel = require('gulp-babel');
var plumber = require('gulp-plumber');
var server = require('gulp-develop-server');

gulp.task('bundle', function() {
  return browserify('client/App.js')
    .transform('babelify', {presets: 'react'})
    .bundle()
    .pipe(source('bundle.js'))
    .pipe(gulp.dest('build/client/'));
});

gulp.task('bundleCoffee', function() {
  return gulp.src('server/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumber())
    .pipe(coffee({bare: true, coffee: require('coffeescript')}))
    .pipe(babel({
       presets: ['import-export']
    }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./build/server'));
});

gulp.task('bundleJs', function() {
  return gulp.src('server/**/*.js')
    .pipe(plumber())
    .pipe(babel({
        presets: ['import-export']
    }))
    .pipe(gulp.dest('./build/server'));
});

gulp.task('bundleServer', ['bundleCoffee', 'bundleJs']);

gulp.task('watchServer', function() {
    gulp.watch('server/**/*.coffee', ['bundleCoffee']);
    gulp.watch('server/**/*.js', ['bundleJs']);
});

gulp.task( 'server:start', ['bundleServer'], function() {
    server.listen( { path: './build/server/server.js' } );
});

gulp.task( 'server:restart', ['server:start'], function() {
    gulp.watch( [ './build/server/**/*' ], server.restart );
});

gulp.task('default', ['watchServer', 'server:restart']);
