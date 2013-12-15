serialport = require 'serialport'

class RF12demo extends serialport.SerialPort
  
  constructor: (device, baudrate =9600) ->
    @info = {}
    
    # construct the serial port object
    super device,
      baudrate: baudrate
      parser: serialport.parsers.readline '\n'

    @on 'data', (datain) =>
      data = datain
      data = data.slice(1, -1) if data.slice(-1) == '\r'
      words = data.split ' '
      #console.log 'got DATA',
      #  datain: datain
      #  data: data
      #  word: words

      tries = 3
     
      while tries--
        if words.shift() == '1'
          #console.log '  first is 1'
	  #and @info.recvid
          ints = words.map (x) -> parseInt x
          head = ints.shift()
          @info.id = head & 0x1F
          @info.head = head
          @info.buffer = new Buffer(ints) 
          # TODO: conversion to ints can fail if the serial data is garbled
          @info.id = words[0] & 0x1F
          @info.buffer = new Buffer(words)
          # generate new events, on generic channel and on node-specific one
          @emit 'packet', @info
          @emit "node-#{@info.id}", @info
          #console.log 'correct at try '
          break

#        else # look for config lines of the form: A i1* g5 @ 868 MHz
#          match = /^ \w i(\d+)\*? g(\d+) @ (\d\d\d) MHz/.exec data
#          if match
#            #console.log '  match'
#            @emit 'config', data, match.slice(1)
#            @info.recvid = parseInt(match[1])
#            @info.group = parseInt(match[2])
#            @info.band = parseInt(match[3])
#          else
#            #console.log '  not match'
#            @emit 'other', data
        
module.exports = RF12demo
