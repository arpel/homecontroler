cosm = require('cosm')

client = new cosm.Cosm('bI-PWNeyFPrHnJOq7tclJGLVjDiSAKxOSlRJNVVYMTBnbz0g')

feedEDFTeleInfo = new cosm.Feed(cosm, {id: 1384112203})
channelHCHC = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Index_HC", queue_size: 1})
channelHCHP = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Index_HP", queue_size: 1})
channelIInst = new cosm.Datastream(client, feedEDFTeleInfo, {id: "I_inst", queue_size: 1})
channelPapp = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Papp", queue_size: 1})
channelVbat = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Vbat", queue_size: 1})

EDFLoopback = require('./serial-EDFLoopback.coffee')

edf = new EDFLoopback '/dev/ttyAMA0'

httpcb = (error, response, body) ->
  console.log("HTTP Error") if error

console.log 'Startup done'

edf.on 'node-99', (packet) ->
   packetindex = packet.buffer.readUInt8(1)
   hchp_indexes = (packet.buffer.readUInt32LE(i) for i in [7, 11])
   iinst = packet.buffer.readUInt16LE(15)
   imax = packet.buffer.readUInt32LE(17)
   papp = packet.buffer.readUInt32LE(21)
   error = packet.buffer.readUInt8(25)

   console.log "EDF TeleInfo",
      temp: ints[0]/100.0
      bat: ints[1]/1000.0
      hchc: hchp_indexes[0]
      hchp: hchp_indexes[1]
      iinst: iinst
      imax: imax
      papp: papp
      error: error
      
   # Sending to Xively   
   #channelHCHC.addPoint(hchp_indexes[0])
   #channelHCHP.addPoint(hchp_indexes[1])
   #channelIInst.addPoint(iinst)
   #channelPapp.addPoint(papp)
   #channelVbat.addPoint(ints[1]/1000.0)
