#!/usr/bin/env ruby

# Name: 		css-colors.rb
# Author: 		Rachael Birky
# Description: 	This script generates an HTML page displaying
# 				 the colors used in a CSS file, sorted by frequency

# include URI library
require 'open-uri'

# Method to check if str is a URL
def is_url(str)
	uri = URI.parse(str)
	(uri.scheme == "http" || uri.scheme == "https")
rescue URI::InvalidURIError
	false
end

# Validate number of command line arguments
if ARGV.length != 2
    STDERR.puts "Usage: #$0 <infile> <outfilename>"
    exit 1
end

# Store infile and outfile strings
infileName = ARGV[0]
outfileName = ARGV[1]

if (! infileName.include?(".css"))
  STDERR.puts "No CSS file given"
  exit 1
end

# Check if infile is a URL
if is_url(infileName)
	infile = open(infileName)
else
	begin
		infile = File.open(ARGV[0], 'r')
	rescue IOError => e
		STDERR.puts "Infile error! #{e}"
  ensure
    infile.close
	end
end

outfile = File.open(ARGV[1], 'w+')

# Define regex for hexadecimal number
regex = /#\h{3,6}/
colors = Hash.new 0

# Read each line, find all matches
infile.each_line { |line|
	matches = line.scan(regex)
	matches.each { |hex|
    if hex.length == 4
      hex = "#" + hex[1]*2 + hex[2]*2 + hex[3]*2
    end
		# Convert each match to a symbol
		hex.to_sym
		# Add to hash table or increment frequency
		if colors.has_key?(hex)
			colors[hex] += 1
		else
			colors[hex] = 1
		end
	}
}

# Sort in descending order
colors = Hash[colors.sort_by { |k,v| v }.reverse]

# Boiler plate output
outfile.write(
"<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\"/>
    <title>Stylesheet Colors</title>
    <style>
      body {
        font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;
        color: #333;
      }
      h1 {
        font-size: 40px;
        font-weight: 300;
        margin: 36px 8px 8px 8px;
        color: #333;
      }
      h2 {
        margin: 0 8px 20px 8px;
        font-size: 18px;
        font-weight: 300;
      }
      h2 a {
        color: #999 !important;
        text-decoration: none;
      }
      h2 a:hover {
        text-decoration: underline;
      }
      .color { 
        height: 200px;
        width: 200px;
        float: left;
        margin: 10px;
        border: 1px solid #000; 
        position: relative;
        -webkit-box-shadow: 0 0 10px #eee; 
        -moz-box-shadow: 0 0 10px #eee; 
        box-shadow: 0 0 10px #eee; 
      }
      .color:hover {
        -webkit-box-shadow: 0 0 10px #666; 
        -moz-box-shadow: 0 0 10px #666; 
        box-shadow: 0 0 10px #666; 
      }
      .info { 
        background-color: #fff;
        background-color: rgba(255,255,255,.5);
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 5px;
        border-top: 1px solid #000;
        font-size: 12px;
        text-align: right;
      }
      .rgb {
        float: left;
      }
    </style>
  </head>
  <body>
      <h1>Stylesheet Colors</h1>
      <h2><a href=\"#{infileName}\">#{infileName}</a></h2>
      ")

# Output each Hex/RGB div
colors.each { |k,v|
  # Convert hex into RGB values
  r=(k[1]+k[2]).hex
  g=(k[3]+k[4]).hex
  b=(k[5]+k[6]).hex
  outfile.write("
  <div class=\"color\" style=\"background-color: #{k}\">
  <div class=\"info\">
    <div class=\"rgb\">
      RGB: #{r}, #{g}, #{b}
    </div>
    <div class=\"hex\">
      Hex: #{k}
    </div>
    <!-- #{v} occurrence(s) -->
  </div>
</div>")
}

# Output EOF
outfile.write('
  </body>
</html>')

if !is_url(infileName)
  infile.close
end

outfile.close

exit 0