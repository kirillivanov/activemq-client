'use strict'
gulp       = require 'gulp'
#routes     = require './src/server.coffee'
express    = require 'express'
bower      = require 'gulp-bower'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
less       = require 'gulp-less'
concat     = require 'gulp-concat'

app = express()

EXPRESS_PORT = 5000
EXPRESS_ROOT = __dirname + "/public"

less_src = [
	'./src/styles/styles.less'
	'./bower_components/bootstrap/less/bootstrap.less'
]

gulp.task 'connect', ->
	app.configure ->
		app.use express.logger 'dev'
		app.use express.bodyParser()
		app.use express.methodOverride()
		app.use express.errorHandler()
		#app.use livereload()
		app.use express.static EXPRESS_ROOT
		app.use app.router
		#routes app

	app.listen EXPRESS_PORT
	#lr = tinylr()
	#lr.listen LIVERELOAD_PORT
	return

gulp.task 'bower', () ->
	bower('./bower_components')

gulp.task 'coffee:scripts', ->
	gulp.src('./src/coffee/*.coffee')
		.pipe(coffee(bare: true).on('error', gutil.log))
		.pipe(gulp.dest('public'))

gulp.task 'copy:index', ->
	gulp.src('./src/index.html')
		.pipe(gulp.dest('public'))

gulp.task 'less:dev', ->
	gulp.src(less_src)
		.pipe(less())
		.pipe(concat('styles.css'))
		.pipe(gulp.dest('public'))

gulp.task 'watch', ->
	gulp.watch(['./src/coffee/*.coffee'], ['coffee:scripts'])
	gulp.watch(['./src/index.html'], ['copy:index'])

gulp.task 'server', ['bower'], () ->
	gulp.start ['coffee:scripts', 'less:dev', 'copy:index', 'connect', 'watch']