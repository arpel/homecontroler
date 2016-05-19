serialport = require 'serialport'

class EDFLoopback extends serialport.SerialPort
  
  constructor: (device, baudrate =9600) ->
    @info = {}
    
    # construct the serial port object
    super device,
      baudrate: baudrate
      parser: serialport.parsers.readline '\n'

    @on 'data', (datain) =>
      data = datain
      data = data.slice(0, -1) if data.slice(-1) == '\r'
      data = data.slice(0, -1) if data.slice(-1) == ' '
      
      words = data.split ' '
      #console.log 'got DATA',
      #  datain: datain
      #  data: data
      #  word: words

      tries = 3
     
      while tries--
        if words.shift() == '1'
          #console.log '  first is 1'
          ints = words.map (x) -> parseInt x
          head = ints.shift()

          @info.id = head
          @info.head = head

          @info.buffer = ints
          @emit 'packet', @info
          @emit "node-#{@info.id}", @info
          break

module.exports = EDFLoopback
