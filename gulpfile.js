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
var log4js = require('log4js')
var logger = log4js.getLogger()

log4js.configure({
  appenders: {
    out: { type: 'stdout', layout: {
      type: 'pattern',
      pattern: '%[[%r] %p%] %m',
    }}
  },
  categories: { default: { appenders: ['out'], level: 'info' } }
});

function coffeescriptTransform(file) {
    var data = '';
    return through(write, end);

    function write (buf) { data += buf }
    function end () {
        if (!file.endsWith('.coffee'))
            result = data
        else 
            result = coffeescript.compile(data);
        this.queue(result);
        this.queue(null);
    }
}

function browserifyTransform(b) {
    return b
        .transform(coffeescriptTransform)
        .transform('babelify', {
            presets: ['env', 'react'],
            plugins: ['react-css-modules'],
            extensions: [".coffee", ".css", '.js']
        });
}

function browserifyFinalize(b) {
    return b
        .bundle()
        .on("error", (err) => {
            logger.error("Browserify error:")
            logger.error(err.stack)
        })        
        .pipe(source('bundle.js'))
        .pipe(gulp.dest('./build/assets/'));
}

gulp.task('assets:js', function() {
    return browserifyFinalize(browserifyTransform(browserify('./client/client.coffee')));
});

gulp.task('assets:js:watch', function() {
    var b = browserify({
        entries: ['./client/client.coffee'],
        cache: {},
        packageCache: {},
        plugin: [watchify],
        extensions: [".js", ".coffee"]
    });
    browserifyTransform(b);
    b.on('update', bundle);
    b.on('log', (msg) => logger.info("Client bundle updated:", msg));
    bundle();
    
    function bundle() {
        browserifyFinalize(b);
    }
});

gulp.task('server:coffee', function() {
  return gulp.src('server/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumber())
    .pipe(coffee({bare: true, coffee: require('coffeescript')}))
    .pipe(babel({
       presets: ['import-export', 'react']
    }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./build/server'));
});

gulp.task('client:coffee', function() {
  return gulp.src('client/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumber())
    .pipe(coffee({bare: true, coffee: require('coffeescript')}))
    .pipe(babel({
       presets: ['import-export', 'react']
    }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./build/client'));
});

gulp.task('server:js', function() {
  return gulp.src('server/**/*.js')
    .pipe(plumber())
    .pipe(babel({
        presets: ['import-export', 'react']
    }))
    .pipe(gulp.dest('./build/server'));
});

gulp.task('server:bundle', ['server:coffee', 'client:coffee', 'server:js']);

gulp.task('server:watch', function() {
    gulp.watch('server/**/*.coffee', ['server:coffee']);
    gulp.watch('client/**/*.coffee', ['client:coffee']);
    gulp.watch('server/**/*.js', ['server:js']);
});

gulp.task( 'server:start', ['server:bundle'], function() {
    server.listen( { path: './build/server/server.js' } );
});

gulp.task( 'server:restart', ['server:start'], function() {
    gulp.watch( [ './build/server/**/*' ], server.restart );
});

gulp.task('default', ['assets:js:watch', 'server:watch', 'server:restart']);
