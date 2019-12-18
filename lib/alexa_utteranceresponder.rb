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
      r.merge(amb.invocation || amb.name => amb)
      
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
    
    model_id = if r2 then
      return respond() if r2[:action] == 'open'      
      r2[:invocation]
    else
      
      puts 'searching all utterances'.info if @debug
      puts ('s: ' + s.inspect).debug if @debug
      
      # attempt to find the request from utterances in all skills
      found = @models.detect do |key, model|
        puts 'utterances: ' + model.utterances.map(&:downcase).inspect if @debug
        model.utterances.map(&:downcase).include? s
      end
      
      id, _ = found[0] if found
    end
      
    return "hmmm, I don't know that one." unless model_id        

    puts ('model_id: ' + model_id.inspect).debug if @debug
    #puts '@models: ' + @models.inspect if @debug
    amb = @models[model_id]
    #puts 'amb: ' + amb.inspect if @debug
    
    aio = AskIO.new(amb.to_manifest, amb.to_model, debug: @debug, 
                      userid: @userid, deviceid: deviceid, modelid: model_id)
        
    
    request = r2 ? r2[:request] : s
    puts ('request: ' + request.inspect).debug if @debug
    r = aio.ask request, &blk
    
    r ? r : "I'm sorry I didn't understand what you said"

  end

end
