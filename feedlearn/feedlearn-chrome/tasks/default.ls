require! {
  \del
  \gulp
  \gulp-livescript
  \gulp-nodemon
  \gulp-sourcemaps
}

gulp.task 'clean', ->
    del ['build/*']

gulp.task 'build', ['ls']

gulp.task 'ls', ->
  return gulp.src 'src/*.ls'
    .pipe(gulp-sourcemaps.init())
    .pipe(gulp-livescript({bare: false}))
    .pipe(gulp-sourcemaps.write('.')) # relative to gulp.dest
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch ['src/*.ls', 'src/manifest.json'], ['dist']

gulp.task 'default', ['watch']