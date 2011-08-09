({
    // the location of all the source files
    appDir: 'src',
    
    // the path to begin looking for modules. this is relative to appDir
    baseUrl: '.',
    
    // the directory to write the compiled scripts. this will emulate the
    // directory structure of appDir
    dir: 'min',
    
    // explicitly specify the optimization method
    optimize: 'uglify',
    
    // no CSS optimization is necessary since we use the sass optimization tool
    optimizeCss: 'none',
    
    // everything is namespaced within the code, therefore this must be
    // here to route 'cilantro' to the baseUrl to ensure the "url" routes
    // to the correct file system location.
    paths: {
        'cilantro': '.'
    },
    
    // an array of modules to compile
    modules: [{
        
        name: 'main'

    }, {

        name: 'workspace/main'

    }, {

        name: 'define/main'

    }, {
        
        name: 'report/main'

    }]
})
