module.exports =
    collection: (name) ->
        methods =
            insert: (params, cb) ->
                cb(false, {})
            find: ->
                operations =
                    limit = (amount) ->
                        result =
                            toArray: (cb) ->
                                cb false, []
                                []
