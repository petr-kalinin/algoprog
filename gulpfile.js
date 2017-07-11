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

function coffeescriptTransform(file) {
    var data = '';
    return through(write, end);

    function write (buf) { data += buf }
    function end () {
        result = coffeescript.compile(data);
        this.queue(result);
        this.queue(null);
    }
}

function browserifyTransform(b) {
    return b
        .transform(coffeescriptTransform)
        .transform('babelify', {presets: ['env'], extensions: [".coffee"]})
        .bundle()
        .pipe(source('bundle.js'))
        .pipe(gulp.dest('./build/client/'));
}

function browserifyFinalize(b) {
    return b
        .bundle()
        .pipe(source('bundle.js'))
        .pipe(gulp.dest('./build/client/'));
}

gulp.task('client:js', function() {
    return browserifyFinalize(browserifyTransform(browserify('./client/client.coffee')));
});

gulp.task('client:js:watch', function() {
    var b = browserify({
        entries: ['./client/client.coffee'],
        cache: {},
        packageCache: {},
        plugin: [watchify]
    });
    browserifyTransform(b);
    b.on('update', bundle);
    b.on('log', (msg) => console.log("Client bundle updated:", msg));
    bundle();
    
    function bundle() {
        browserifyFinalize(b);
    }
});

gulp.task('client:html', function() {
  return gulp.src('client/**/*.html')
    .pipe(gulp.dest('./build/client'));
});

gulp.task('client:bundle:watch', ['client:js:watch', 'client:html']);

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

gulp.task('default', ['client:bundle:watch', 'watchServer', 'server:restart']);
