RF12demo = require('./serial-RF12demo.coffee')

rfm = new RF12demo '/dev/ttyAMA0'

rfm.on '', (packet) ->
   console.log 'gotIT'
