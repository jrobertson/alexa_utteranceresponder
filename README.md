# Introducing the alexa_utteranceresponder gem


## Usage

    require 'rsc'
    require 'alexa_utteranceresponder'

    rsc = RSC.new('rse.home')


    modelmds = ['dfs://dfs.home/www/jamesrobertson.eu/alexa/leo.txt']
    userid = 'amzn1.ask.account.someid'
    deviceid = "amzn1.ask.device.somedevice"
    aur = AlexaUtteranceResponder.new(modelmds, userid: userid, deviceid: deviceid, debug: true)
    utterance = 'ask Leo what can I say'
    aur.ask(utterance) do |h|

      puts 'h: ' + h.inspect
      rsc.alexa.skillresponse.run h

    end

Provide an utterance, deviceid, userid, to allow the gem to verify the utterance matches with the known skill using the invocation name. Then it runs the intent through the alexa_skillresponse gem to process the response.

## Resources

* alexa_utteranceresponder https://rubygems.org/gems/alexa_utteranceresponder

alexa alexautteranceresponder
