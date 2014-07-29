module.exports = (type, acl, middleware) ->
    RestfulDB = require("./databases/#{type}")
    middleware = require("./middleware/#{middleware}")
    middleware(acl, new RestfulDB acl)
