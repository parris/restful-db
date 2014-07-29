Mixable = require 'mixablejs'

baseDBMixin = require './base_db_mixin'
Mongo = require './mongo'
mongoMock = require './mongo_mock'
responseMock = require './response_mock'

describe 'Base DB Mixin', ->

    beforeEach ->
        class @PassingResfulDB extends Mixable
            protectedMethods: ['generic']
            generic: (req, res) ->

        @PassingResfulDB.mixin baseDBMixin

        @createRestfulDB = =>
            new @PassingResfulDB

    it 'creates a DB class successfully', ->
        @createRestfulDB.should.not.throw()

    it 'defaults max limit to 20', ->
        aNewDB = @createRestfulDB()
        aNewDB.defaults.maxLimit.should.equal 20

    describe 'method protection', ->

        beforeEach ->
            @accessList =
                users: ['create']

            @validFakeRequest =
                db: mongoMock
                params:
                    collection: 'users'
                    method: 'create'

            @invalidFakeRequest =
                db: mongoMock
                params:
                    collection: 'users'
                    method: 'index'

            @fakeResponse = responseMock.create()

            @mongo = new Mongo(@accessList)

        afterEach ->
            @fakeResponse.clean()

        it 'does not allow access to users/index', ->
            @mongo.index(@invalidFakeRequest, @fakeResponse)
            @fakeResponse.submittedStatus.should.equal 401

        it 'allows access to users/create', ->
            @mongo.create(@validFakeRequest, @fakeResponse)
            @fakeResponse.submittedStatus.should.equal 200
