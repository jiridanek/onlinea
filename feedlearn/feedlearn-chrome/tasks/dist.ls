require! {
  \gulp
  \gulp-zip
}

gulp.task 'dist', ['build'], ->
    return gulp.src(['src/*.js', 'third_party/*.js', 'build/*', 'src/manifest.json'])
        .pipe(gulp.dest('dist'))

gulp.task 'zip', ['dist'], ->
    manifest = require('../src/manifest')
    distFileName = manifest.shortname + 'v' + manifest.version + '.zip'
    return gulp.src(['build/*', '!build/*.map'])
        .pipe(gulp-zip(distFileName))
        .pipe(gulp.dest('dist'))