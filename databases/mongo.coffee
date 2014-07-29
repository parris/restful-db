_ = require 'lodash'
mongoskin = require 'mongoskin'
Mixable = require 'mixablejs'

baseDBMixin = require './base_db_mixin'

class RestfulMongo extends Mixable

    defaults: {}

    @protectedMethods: ['index', 'create', 'read', 'update', 'destroy']

    constructor: (@accessList) ->
        super()

    _getParams: (req) =>
        params = _.extend(
            {},
            _.omit(req.params, ['collection', 'limit']),
            req.query
        )

        _.each params, (val, key) ->
            if not isNaN Number(val)
                params[key] = Number val
            if key == '_id'
                params[key] = mongoskin.helper.toObjectID val

            if val[0] == '{'
                try
                    params[key] = JSON.parse val
                catch e
                    if e instanceof SyntaxError
                        console.log "restful-db: unexpected lookup. collection: #{req.params.collection}, key: #{key}, value: #{val}"

        params

    index: (req, res) =>
        if res?.submittedStatus
            return

        lookup = req.db.collection(req.params.collection).find(@_getParams(req))
            .limit(Math.min(req.query.limit or @defaults.maxLimit))

        lookup.toArray @_render(res)

    create: (req, res) =>
        if res?.submittedStatus
            return

        req.db.collection(req.params.collection).insert req.body, @_render(res)

    read: (req, res) =>
        if res?.submittedStatus
            return

        id = mongoskin.helper.toObjectID req.params._id

        req.db.collection(req.params.collection).findById id, @_render(res)

    update: (req, res) =>

    destroy: (req, res) =>


RestfulMongo.mixin baseDBMixin

module.exports = RestfulMongo
