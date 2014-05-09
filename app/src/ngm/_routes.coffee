module.exports =
  app: (data)->
    return (req, res)->
      res.render __dirname + '/templates/angular-app', data