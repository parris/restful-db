module.exports =
    create: ->
        json: (status, body) ->
            if @submittedResponse
                throw 'You can\'t submit more than 1 response'

            if not body
                body = status
                @submittedStatus = 200
            else
                @submittedStatus = status

            @submittedResponse = body

        clean: ->
            delete @submittedStatus
            delete @submittedResponse
