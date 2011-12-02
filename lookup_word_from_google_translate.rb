#!/usr/bin/ruby
require "rubygems"
require 'open-uri'
require 'json'
require 'yaml'
require 'cgi'
require 'iconv'
require 'pp'
require 'optparse'


def save_yaml(dictionary_file, dict) 
  if (!ARGV[0].nil?)
    print "Saving yaml: DO NOT interrupt script or you will corrupt the file\n\n"
    YAML::dump(dict, File.open(dictionary_file, "w"))
   end
end 


options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.on("-f", "--from LANG", "Language to translate from") do |lang|
      options[:from] = lang
    end

    opts.on("-t", "--to LANG", "Language to translate to") do |lang|
      options[:to] = lang
    end

    opts.on("-d", "--directory DIR", "Directory that contains the data files") do |dir|
      options[:dir] = dir
    end

  end.parse!

pp options

key         = 'ABQIAAAABnSa3_sPKGpTi8ZmdBBxphTgxqRJcu20N4RMOQUb6Zg3va1QqRREPSv_-qEeJdbD5c9vQ_GTZ_yKpg'

if (options[:dir].nil?)
  dictionary_file = "#{options[:from]}2#{options[:to]}.yaml"
else
  dictionary_file = "#{options[:dir]}/#{options[:from]}2#{options[:to]}.yaml"
end

dictionary = YAML.load(dictionary_file)
#pp(dictionary)

if (!dictionary)
  dictionary={}
end



count=0
STDIN.each { |word|
  
  word.chomp!
  word.gsub!(/ /, "")
  
  if (!dictionary[word].nil?)
    print "Word #{word} already in dictionary\n"
    next
  end
  
  
  sleep(1)

params      = "key=#{key}&source=#{options[:from]}&target=#{options[:to]}&q=#{word}"
  print "#{params}\n\n"

uri         = "https://www.googleapis.com/language/translate/v2?#{params}"
  print "#{uri}\n\n"
url         = URI.parse(uri)
json        = url.open.read
out         = JSON.parse(json)
translation = out["data"]["translations"][0]["translatedText"]
nicer       = Iconv.iconv("UTF-8", "UTF-8", translation)
puts nicer

  
 # url = 'http://translate.google.com/translate_a/t?client=t&text=' + CGI.escape(word) + '&sl=es&tl=en&otf=2&pc=0'
#  url = 'http://translate.google.com/translate_a/t?client=t&text=' + CGI.escape(word) + '&hl=en&sl=' + options[:from] + '&tl='+options[:to]+'&multires=1&otf=2&ssel=0&tsel=0&sc=1'
  
  #buffer = open(url, "UserAgent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-US) AppleWebKit/53 (KHTML, like Gecko) Chrome/4.0.249.43 Safari/532.5" ).read
#  buffer = `curl -s -A "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.0.249.43 Safari/532.5" "#{url}" `
  
#  print url + "\n"
#  print buffer
#  print "\n\n"
  # convert JSON data into a hash
#  result = JSON.parse(buffer)
  
#  Definition=""
#  if result['dict']
#    def_array = []
#    result['dict'].reverse.each { |term|
#      def_temp = term['pos']
#      def_temp += ": " unless term['pos'] == ""
#      def_temp += term['terms'].join(", ")
#      def_array.push(def_temp) 
#    }
#    definition = def_array.join("; ")
#  else 
#    result['sentences'].each { |sentence| 
 #     sentence['trans'].gsub!(/\s$/, "")
 #     if (sentence['orig'].downcase == sentence['trans'].downcase || sentence['trans'] == "" || sentence['trans'].nil? ) 
  #   	next
   #   else 
#        definition =""
 #       if (sentence['orig'] != word)
  #        definition += sentence['orig']
   #       definition += ": "
    #    end
#        definition += sentence['trans']
#        definition += " "
#      end
#    }
    
#  end
 
  if (word && definition != "") 
    print "#{definition} \n"
    dictionary[word] = definition
    print "count is #{count} \n\n"
    if (count > 1000) 
      save_yaml(dictionary)
      count = 0
    else 
      count = count + 1
    end
    
  else 
    print "Nothing found\n"
  end
  
}

print "\n\n"
#print dictionary.to_yaml
if (count > 0) 
  save_yaml(dictionary_file, dictionary)
end
