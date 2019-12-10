#!/usr/bin/env ruby

# file: alexa_utteranceresponder.rb

# description: Checks an utterance against an invocation keyword from
#              the available skills and returns an Alexa formatted response 
#              to be passed to the skill's endpoint service.

require 'askio'
require 'alexa_modelbuilder'


class AlexaUtteranceResponder
  using ColouredText
  
  attr_reader :invocation
  attr_accessor :deviceid

  def initialize(modelmds=[], debug: false, userid: nil, deviceid: nil)
    
    @debug, @userid, @deviceid = debug, userid, deviceid

    @models = modelmds.inject({}) do |r,x|
      
      amb = AlexaModelBuilder.new(x)
      r.merge(amb.invocation => amb)
      
    end    
    
  end
  
  def ask(s, deviceid: @deviceid, &blk)
    
    puts
    puts '  debugger: s: ' + s.inspect if @debug

    invocations = @models.keys.map {|invocation| invocation.gsub(/ /,'\s') }\
        .join('|')
    puts 'invocations: ' + invocations.inspect if @debug
    
    regex = %r{

      (?<ask>(?<action>tell|ask)\s(?<invocation>#{invocations})\s(?<request>.*)){0}
      (?<open>(?<action>open)\s(?<invocation>#{invocations})){0}
      \g<ask>|\g<open>
    }x
        
    r2 = s.downcase.gsub(/,/,'').match(regex)
    
    puts '  debugger: r2: ' + r2.inspect if @debug
    puts      
      
    return "hmmm, I don't know that one." unless r2        
    return respond() if r2[:action] == 'open'

    puts '@models: ' + @models.inspect if @debug
    amb = @models[r2[:invocation]]
    puts 'amb: ' + amb.inspect if @debug
    
    aio = AskIO.new(amb.to_manifest, amb.to_model, debug: @debug, 
                      userid: @userid, deviceid: deviceid)
        
    puts 'request: ' + r2[:request].inspect if @debug
    r = aio.ask r2[:request], &blk
    
    r ? r : "I'm sorry I didn't understand what you said"

  end

end

