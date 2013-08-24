require 'bundler'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Partial_Demo
  class App < Sinatra::Application

    before do 
      @cat = Cat.new
    end

    #routes
    get '/' do
      erb :index
    end

    get '/forbidden' do
      403
    end

    helpers do

        def beg_partial(template)
          erb template
        end
    
        def int_partial(template,locals=nil)
          locals = locals.is_a?(Hash) ? locals : {template.to_sym => locals}
          template=('_' + template.to_s).to_sym
          erb template, locals       
        end
   
        def adv_partial(template,locals=nil)
          if template.is_a?(String) || template.is_a?(Symbol)
            template=('_' + template.to_s).to_sym
          else
            locals=template
            template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym
          end
          if locals.is_a?(Hash)
            erb(template,{:layout => false},locals)      
          elsif locals
            locals=[locals] unless locals.respond_to?(:inject)
            locals.inject([]) do |output,element|
              output << erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
            end.join("\n")
          else 
            erb(template,{:layout => false})
          end
        end

    end

  end
end