Cache = require "./cache"
q = require "q"
request = require "request"

cache = new Cache { stdTTL: 60, checkperiod: 120 }

module.exports = (options = {}) ->
  defer = q.defer()
  key = JSON.stringify options

  options.expiration ?= 60

  cache.get key
  .then defer.resolve
  .catch ->
    request options, (err, response, body) ->
      return defer.reject err if err?
      cache.set key, body, options.expiration
      defer.resolve body

  defer.promise
