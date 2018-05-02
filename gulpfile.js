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

function logError(title, err) {
    logger.error(title);
    logger.error(err.stack);
}

function logSuccess(title) {
    logger.info(title);
}

function logServerRestarted() {
    logSuccess("Server restarted");
}

function plumb() {
    return plumber({
        errorHandler: function (err) {
            logError("Plumber error", err);
            this.emit('end');
        }
    });
}

function coffeescriptTransform(file) {
    var data = '';
    return through(write, end);

    function write (buf) { data += buf }
    function end () {
        if (!file.endsWith('.coffee'))
            result = data
        else
            try {
                result = coffeescript.compile(data);
            } catch (err) {
                logError("Coffeescript error", err);
            }
        this.queue(result);
        this.queue(null);
    }
}

function browserifyTransform(b) {
    return b
        .plugin(require('css-modulesify'), {
            rootDir: __dirname,
            output: './build/assets/bundle.css'
        })
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
        .on('uncaughtException', (err) => {
            logError("Browserify error", err)
        })
        .on("error", (err) => {
            logError("Browserify error", err)
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
    b.on('log', (msg) => logSuccess("Client bundle updated: " + msg));
    bundle();

    function bundle() {
        browserifyFinalize(b);
    }
});

gulp.task('client:css', function() {
  return gulp.src('client/**/*.css')
    .pipe(gulp.dest('./build/client'));
});

gulp.task('client:coffee', function() {
  return gulp.src('client/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumb())
    .pipe(coffee({bare: true, coffee: require('coffeescript')}))
    .pipe(babel({
       presets: ['import-export', 'react']
    }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./build/client'));
});

gulp.task('server:coffee', function() {
  return gulp.src('server/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumb())
    .pipe(coffee({bare: true, coffee: require('coffeescript')}))
    .pipe(babel({
       presets: ['import-export', 'react']
    }))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./build/server'));
});

gulp.task('server:js', function() {
  return gulp.src('server/**/*.js')
    .pipe(plumb())
    .pipe(babel({
        presets: ['import-export', 'react']
    }))
    .pipe(gulp.dest('./build/server'));
});

gulp.task('server:bundle',  gulp.parallel('server:coffee', 'client:coffee', 'server:js', 'client:css'));

gulp.task('server:watch', function() {
    gulp.watch('client/**/*.coffee', gulp.series('client:coffee'));
    gulp.watch('client/**/*.css', gulp.series('client:css'));
    gulp.watch('server/**/*.coffee', gulp.series('server:coffee'));
    gulp.watch('client/**/*.coffee', gulp.series('server:coffee'));
    gulp.watch('server/**/*.js', gulp.series('server:js'));
});

gulp.task( 'server:start', gulp.series('server:bundle', function() {
    //server.listen( { path: './build/server/server.js', execArgv: ["--inspect=0.0.0.0:4040"] } );
    server.listen( { path: './build/server/server.js' } );
}));

gulp.task( 'server:restart', gulp.series('server:start', function() {
    gulp.watch( [ './build/server/**/*' ], server.restart );
    gulp.watch( [ './build/client/**/*' ], server.restart );
}));

gulp.task('default',  gulp.parallel('assets:js:watch', 'server:watch', 'server:restart'));
