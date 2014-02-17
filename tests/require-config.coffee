require.config
  baseUrl: '/dist/js'

  # deps: [""]

  shim:
    "underscore":
      exports: "_"

    "backbone":
      exports: "Backbone"
      deps: [
        "jquery"
        "underscore"
      ]

  paths:
    "backbone": "../vendor/backbone-min"
    "underscore" : "../vendor/underscore-min"
    "jquery" : "../vendor/jquery-1.11.0.min"
