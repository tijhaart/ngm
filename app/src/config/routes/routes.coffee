module.exports = (options, imports, register)->

  register null,
    "config.routes": {
      "/api/0/savechanges/": {
        method: "POST"
      }
      "/": "index.html"
    }