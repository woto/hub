require 'nokogiri'

file_full_path = '/Users/r.kornev/work/_/hub/data/feeds/318-durastore-713-main'

Nokogiri::XML.Reader(File.open(file_full_path)).each do |zzz|
  p zzz
end
