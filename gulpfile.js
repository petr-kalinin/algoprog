var gulp = require('gulp');
var sourcemaps = require('gulp-sourcemaps');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var coffee = require('gulp-coffee');
var babel = require('gulp-babel');
var plumber = require('gulp-plumber');
var server = require('gulp-develop-server');
var coffeescript = require('coffeescript');
var through = require('through');

gulp.task('client:js', function() {
    return browserify('./client/client.coffee')
        .transform(function (file) {
                var data = '';
                return through(write, end);

                function write (buf) { data += buf }
                function end () {
                    result = coffeescript.compile(data);
                    this.queue(result);
                    this.queue(null);
                }
        })
        .transform('babelify', {presets: ['env'], extensions: [".coffee"]})
        .bundle()
        .pipe(source('bundle.js'))
        .pipe(gulp.dest('./build/client/'));
});

gulp.task('client:html', function() {
  return gulp.src('client/**/*.html')
    .pipe(gulp.dest('./build/client'));
});

gulp.task('client:bundle', ['client:js', 'client:html']);

gulp.task('server:coffee', function() {
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

gulp.task('server:js', function() {
  return gulp.src('server/**/*.js')
    .pipe(plumber())
    .pipe(babel({
        presets: ['import-export']
    }))
    .pipe(gulp.dest('./build/server'));
});

gulp.task('server:bundle', ['server:coffee', 'server:js']);

gulp.task('watchServer', function() {
    gulp.watch('server/**/*.coffee', ['server:coffee']);
    gulp.watch('server/**/*.js', ['server:js']);
});

gulp.task( 'server:start', ['server:bundle'], function() {
    server.listen( { path: './build/server/server.js' } );
});

gulp.task( 'server:restart', ['server:start'], function() {
    gulp.watch( [ './build/server/**/*' ], server.restart );
});

gulp.task('default', ['client:bundle', 'watchServer', 'server:restart']);
