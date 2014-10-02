Rails.logger.info "Loading lib\\application ..."
folder = Rails.root.join 'lib', 'application'
if File.exist? folder
  Dir.entries(folder).sort.each do |file|
    if file =~ /.rb$/
      Rails.logger.info "... #{file}"
      require folder.join file
    end
  end
end