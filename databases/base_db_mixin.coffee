_ = require 'lodash'

# baseDBMixin
#
# Sets a default maxLimit for findAll type requests.
#
# Mix this class in to get methods protected for some accessList.
# Every mixed class should contain a @protectedMethods class attribute.
# @example
#   class MyDB extends Mixable
#     protectedMethods: ['generic']
#
#   MyDB.mixin baseDBMixin
baseDBMixin = ->
    @addToObj 'defaults', {
        maxLimit: 20
    }

    isMethodAllowed = (collection, method, accessList) ->
        isCollectionAllowed = collection in _.keys accessList
        isCollectionAllowed and method in accessList[collection]

    @.prototype._render = (res) -> (err, data) ->
        if err
            res.json err
        else
            res.json data

    @protect = (method) ->
        @before method, (req, res) ->
            if not isMethodAllowed req.params.collection, method, @accessList
                res.json 401, { error: 'Forbidden' }

    if @protectedMethods?.length
        @protect(method) for method in @protectedMethods

module.exports = baseDBMixin
