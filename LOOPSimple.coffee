cosm = require('cosm')

client = new cosm.Cosm('WgyjfmBLavslYQ5iFjmWQ1FAlPvhTXNZCrNOXdUzvTj5qBYR')

feedEDFTeleInfo = new cosm.Feed(cosm, {id: 549635376})
channelHCHC = new cosm.Datastream(client, feedEDFTeleInfo, {id: "HCHC", queue_size: 1})
channelHCHP = new cosm.Datastream(client, feedEDFTeleInfo, {id: "HCHP", queue_size: 1})
channelIInst = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Iinst", queue_size: 1})
channelPapp = new cosm.Datastream(client, feedEDFTeleInfo, {id: "Papp", queue_size: 1})

EDFLoopback = require('./serial-EDFLoopback.coffee')

edf = new EDFLoopback '/dev/ttyAMA0'

httpcb = (error, response, body) ->
  console.log("HTTP Error") if error

console.log 'EDF Loopback - Startup done'

edf.on 'node-99', (packet) ->
   console.log "Incoming DATA",
      packet: packet.buffer

   packetindex = packet.buffer[0]
   hchc = packet.buffer[1]
   hchp = packet.buffer[2]
   iinst = packet.buffer[3]
   papp = packet.buffer[4]
   error = packet.buffer[5]

   console.log "EDF TeleInfo",
      hchc: hchc
      hchp: hchp
      iinst: iinst
      papp: papp
      error: error
      
   # Sending to Xively   
   channelHCHC.addPoint(hchc)
   channelHCHP.addPoint(hchp)
   channelIInst.addPoint(iinst)
   channelPapp.addPoint(papp)
