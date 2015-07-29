require 'URI'

def is_url(str)
	uri = URI.parse(str)
	(uri.scheme == "http" || uri.scheme == "https")
rescue URI::InvalidURIError
	false
end

puts is_url(ARGV[0])

#if line =~ /#\h{3,6}/
	#matches << regex.match(line)
	# key = $&.to_sym
	# puts key
#end

# <div class="color" style="background-color: #ffffff">
#   <div class="info">
#     <div class="rgb">
#       RGB: 255, 255, 255
#     </div>
#     <div class="hex">
#       Hex: #ffffff
#     </div>
#     <!-- 9 occurrence(s) -->
#   </div>
# </div>