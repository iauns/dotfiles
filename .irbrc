begin
  # Load wirble
  require 'wirble'
  
  # Start wirble
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end

begin
  require 'fileutils'
rescue LoadError => err
  warn "Couldn't load FileUtils: #{err}"
end
