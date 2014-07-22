module.exports = (helper)->

  modelCfg =
    name: 'acl'
    options:
      base: 'ACL'
    public: false

  helper.register modelCfg

  return modelCfg