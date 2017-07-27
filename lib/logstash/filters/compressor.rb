
require 'java'
require "logstash/filters/base"
require "logstash/namespace"

require File.expand_path(File.dirname(__FILE__))<<"/LoggingExtension-1.0.jar"

module Sample
	include_package "com.tavisca.oski.loggingextension.compression"
end

class LogStash::Filters::Compressor < LogStash::Filters::Base

	# Setting the config_name here is required. This is how you
	# configure this filter from your logstash config.

	config_name "compressor"

	# New plugins should start life at milestone 1.
	milestone 1
	
	#set the type of compression
	config :type, :validate => :string, :default => "gzip"
	
	#set action compression or decompression
	config :action, :validate => :string  , :default => "decompression" 
	
	
	public
	def register
		# nothing to do
	end # def register

	public
	def filter(event)
		# return nothing unless there's an actual filter event
		#return unless filter?(event)
		
		
		if event["message"]
			if @type =="snappy"
				compressorobj=Sample::Snappy_Compressor.new
			elsif @type == "gzip"
				compressorobj=Sample::GZip_Compressor.new
			end
				
			if @action =="compression"					
				event["message"] = compressorobj.CompressAndEncodeToBase64String(event["message"])	
			elsif @action == "decompression"
				event["message"] = compressorobj.DecodeBase64StringAndDeCompress(event["message"])
			end
		end
		
	# filter_matched should go in the last line of our successful code
	filter_matched(event)
	end # def filter
end # class LogStash::Filters::Foo

