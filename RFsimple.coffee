cosm = require('cosm')

client = new cosm.Cosm('bI-PWNeyFPrHnJOq7tclJGLVjDiSAKxOSlRJNVVYMTBnbz0g')
feed = new cosm.Feed(cosm, {id: 97289})
feedVBAT = new cosm.Feed(cosm, {id: 99851})
stream2TEMP = new cosm.Datastream(client, feed, {id: 1, queue_size: 1})
stream2VBAT = new cosm.Datastream(client, feedVBAT, {id: 2, queue_size: 1})
stream3TEMP = new cosm.Datastream(client, feed, {id: 3, queue_size: 1})
stream3VBAT = new cosm.Datastream(client, feedVBAT, {id: 3, queue_size: 1})
stream10TEMP1 = new cosm.Datastream(client, feed, {id: 5, queue_size: 1})
stream10VBAT = new cosm.Datastream(client, feedVBAT, {id: 10, queue_size: 1})
stream10TEMP2 = new cosm.Datastream(client, feed, {id: 6, queue_size: 1})
stream6TEMP = new cosm.Datastream(client, feed, {id: 8, queue_size: 1})
stream6VBAT = new cosm.Datastream(client, feedVBAT, {id: 6, queue_size: 1})
stream7TEMP = new cosm.Datastream(client, feed, {id: 9, queue_size: 1})
stream7VBAT = new cosm.Datastream(client, feedVBAT, {id: 7, queue_size: 1})

RF12demo = require('./serial-RF12demo.coffee')

rfm = new RF12demo '/dev/ttyAMA0'

httpcb = (error, response, body) ->
  console.log("HTTP Error") if error

console.log 'Startup done'

rfm.on 'node-2', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   ints = (packet.buffer.readInt16LE(2*i) for i in [1..2])
   now = new Date()
   console.log "Sonde temperature 2",
      packetindex: packetindex
      temp: ints[0]/100.0
      bat: ints[1]/1000.0
      #ints: ints
   # Sending to COSM
   stream2TEMP.addPoint(ints[0]/100.0)
   stream2VBAT.addPoint(ints[1]/1000.0)

rfm.on 'node-3', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   ints = (packet.buffer.readInt16LE(2*i) for i in [1..2])
   now = new Date()   
   console.log "Sonde temperature 3 (Ext)",
      #date: now
      datejson: now.toJSON()
      packetindex: packetindex
      temp: ints[0]/100.0
      bat: ints[1]/1000.0
      #ints: ints
   # Sending to COSM
   stream3TEMP.addPoint(ints[0]/100.0)
   stream3VBAT.addPoint(ints[1]/1000.0)

rfm.on 'node-10', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   ints = (packet.buffer.readInt16LE(2*i) for i in [1..3])
   console.log "Sonde temperature 10 (Chaudiere)",
      packetindex: packetindex
      temp1: ints[0]/100.0
      temp2: ints[2]/100.0
      bat: ints[1]/1000.0
      ints: ints
   # Sending to COSM
   stream10TEMP1.addPoint(ints[0]/100.0)
   stream10TEMP2.addPoint(ints[2]/100.0)
   stream10VBAT.addPoint(ints[1]/1000.0)

rfm.on 'node-6', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   ints = (packet.buffer.readInt16LE(2*i) for i in [1..2])
   console.log "Sonde temperature 6 (Chambre)",
      temp: ints[0]/100.0
      bat: ints[1]/1000.0
   # Sending to COSM
   stream6TEMP.addPoint(ints[0]/100.0)
   stream6VBAT.addPoint(ints[1]/1000.0)

rfm.on 'node-7', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   ints = (packet.buffer.readInt16LE(2*i) for i in [1..2])
   console.log "Sonde temperature 7 (Salon)",
      temp: ints[0]/100.0
      bat: ints[1]/1000.0
   # Sending to COSM
   stream7TEMP.addPoint(ints[0]/100.0)
   stream7VBAT.addPoint(ints[1]/1000.0)
