sense = require('sense')

client = new sense.Sense('beX89ZIkep_nZigYGS953A')
feed = new sense.Feed(sense, {id: 0})
stream2TEMP = new sense.Datastream(client, feed, {id: 25134, queue_size: 1})
stream2VBAT = new sense.Datastream(client, feed, {id: 25135, queue_size: 1})

console.log 'TEST Startup done'

cb = (error, response, body)->
  console.log(error)
  console.log(response)
  console.log(body)

stream2TEMP.addPoint(12345/100.0, 1, callback = cb)
stream2VBAT.addPoint(12345/1000.0, 1, callback = cb)

