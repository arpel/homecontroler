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
      data = data.slice(1, -1) if data.slice(-1) == '\r'
      words = data.split ' '
      console.log 'got DATA',
        datain: datain
        data: data
        word: words

      tries = 3
     
      while tries--
        if words.shift() == '99'
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

module.exports = EDFLoopback
