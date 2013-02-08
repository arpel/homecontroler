cosm = require('cosm')

client = new cosm.Cosm('bI-PWNeyFPrHnJOq7tclJGLVjDiSAKxOSlRJNVVYMTBnbz0g')
feed = new cosm.Feed(cosm, {id: 97289})
stream2TEMP = new cosm.Datastream(client, feed, {id: 1, queue_size: 1})
stream2VBAT = new cosm.Datastream(client, feed, {id: 2, queue_size: 1})
stream3TEMP = new cosm.Datastream(client, feed, {id: 3, queue_size: 1})
stream3VBAT = new cosm.Datastream(client, feed, {id: 4, queue_size: 1})
stream10TEMP1 = new cosm.Datastream(client, feed, {id: 5, queue_size: 1})
stream10VBAT = new cosm.Datastream(client, feed, {id: 7, queue_size: 1})
stream10TEMP2 = new cosm.Datastream(client, feed, {id: 6, queue_size: 1})

console.log 'Deleting'

