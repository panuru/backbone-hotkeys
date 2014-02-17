module.exports = function(grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		clean: {
			all: ['dist/**/*']
		},
		copy: {
			'static': {
				files: [
					{ expand: true, cwd: 'vendor/', src: ['**/*.js', '**/*.map'], dest: 'dist/vendor/' }
				]
			}
		},
		coffee: {
			src: {
				expand: true,
				cwd: 'src/',
				src: ['**/*.coffee'],
				dest: 'dist/js/',
				ext: '.js'
			},
			tests: {
				expand: true,
				cwd: 'tests/',
				src: ['**/*.coffee'],
				dest: 'dist/tests/',
				ext: '.js'
			}
		},
    coffeelint: {
      options: {
        'no_trailing_whitespace': { level: 'ignore' },
        'max_line_length': { level: 'ignore' },
      },
    	src: {
        app: ['src/**/*.coffee']
      },
      tests: {
        app: ['tests/**/*.coffee']
      }
    },
		connect: {
			tests: {
				options: {
					port: '?',
					base: '.',
					middleware: function(connect, options) {
						var middlewares = [];
						var directory = options.directory || options.base[options.base.length - 1];
						if (!Array.isArray(options.base)) {
							options.base = [options.base];
						}
						options.base.forEach(function(base) {
							// Serve static files.
							middlewares.push(connect.static(base));
						});
						// Make directory browse-able.
						middlewares.push(connect.directory(directory));
						return middlewares;
					}
				}
			}
		},
		jasmine: {
			basic: {
				src: [
					'app/**/*.js'
				],
				options: {
					specs: 'dist/tests/**/*.js',
					keepRunner: true,
					host: "http://127.0.0.1:<%= connect.tests.options.port %>",
					template: require('grunt-template-jasmine-requirejs'),
					templateOptions: {
						requireConfigFile: 'dist/tests/require-config.js',
					},
          outfile: 'index.html'
				}
			}
		},
		watch: {
			src: {
				files: ['src/**/*.coffee', 'tests/**/*.coffee'],
				tasks: ['build' /*, 'test'*/]
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-jasmine');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-coffeelint');

	grunt.registerTask('build', ['clean', 'copy', 'coffee', 'coffeelint']);
	grunt.registerTask('test', ['connect', 'jasmine']);
	grunt.registerTask('default', ['build', /*'test',*/ 'watch']);

};
