module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.initConfig({
    uglify: {
      js: {
        files: { 'out/built.min.js': [
          "out/scripts/script.js",
          "out/vendor/fancybox/jquery.fancybox.pack.js"
        ] }
      }
    },
    cssmin: {
      combine: {
        dest: 'out/built.min.css',
        src: [
          "out/styles/twitter-bootstrap.css",
          "out/styles/style.css",
          "out/vendor/fancybox/jquery.fancybox.css"
        ]
      }
    }
  });
};

