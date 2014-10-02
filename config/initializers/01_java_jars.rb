require 'java'

Dir.entries("#{Rails.root}/lib").sort.each do |entry|
  if entry =~ /.jar$/
    require entry
  end
end

#java_import 'org.springframework.security.core.context.SecurityContextHolder'