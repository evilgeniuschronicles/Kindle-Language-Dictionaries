#!/usr/bin/ruby
require "rubygems"
require 'open-uri'
require 'json'
require 'yaml'
require 'cgi'
require 'iconv'
require 'pp'

class String
 def translit
   Iconv.iconv('ascii//translit', 'utf-8', self)[0]
 end
end

#begin
dictionary = YAML.load(File.open(ARGV[0]))
#rescue
#dictionary = {}
#end

if (!dictionary)
  dictionary={}
end

#sorted = dictionary.sort {|a,b| a[0].translit<=>b[0].translit}
sorted = dictionary.sort {|a,b| a[0]<=>b[0]}

sorted.each { |term, definition|

puts "#{term}\t#{definition}\n"

}