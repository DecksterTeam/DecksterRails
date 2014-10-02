require 'fileutils'

def get_absolute_path(relative_path)
  "#{Dir.getwd}#{relative_path}"
end

destination_path = '/lib/'
source_path = '/target/mtheory/WEB-INF/lib/'

FileUtils.rm_rf(Dir.glob("#{get_absolute_path(destination_path)}*.jar"))
FileUtils.copy(Dir.glob("#{get_absolute_path(source_path)}*.jar"), get_absolute_path(destination_path))

FileUtils.rm_rf(Dir.glob("#{get_absolute_path('/target/mtheory/')}*"))
FileUtils.rm_rf("#{get_absolute_path('/src/')}")
puts Dir.glob("#{get_absolute_path(destination_path)}*.jar")
