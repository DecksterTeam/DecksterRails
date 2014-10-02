require 'fileutils'

target_directory =  "#{Dir.getwd}/src/main/webapp/WEB-INF"
puts target_directory
FileUtils.mkdir_p target_directory
File.open(target_directory << "/web.xml", 'w') {|f| f.write('')}