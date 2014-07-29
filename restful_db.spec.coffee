express = require 'express'

restfulDB = require './restful_db'

describe 'Restful DB Loader', ->

    beforeEach ->
        @accessList =
            users: ['find']

    it 'finds the mongo database class', ->
        loader = restfulDB 'mongo', @accessList, 'express'

    it 'throws for non-existant database classes', ->
        createRestfulDB = ->
            restfulDB 'zvzvzvz', @accessList, 'express'

        createRestfulDB.should.throw "Cannot find module './databases/zvzvzvz'"

