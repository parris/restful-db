express = require 'express'

Mongo = require '../databases/mongo'

module.exports = (acl, db) ->
    router = express.Router()

    router.get '/', (req, res) ->
        res.json 200, { message: 'restful-db' }
    router.get '/:collection', db.index
    router.post '/:collection', db.create
    router.get '/:collection/:_id', db.read
    router.put '/:collection/:_id', db.update
    router.delete '/:collection/:_id', db.destroy

    router
