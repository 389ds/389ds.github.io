require 'rack/jekyll'

use Rack::Static,
  # Poor man's redirects
  :urls => {
    "/favicon.ico" => "/images/favicon.ico"
  }


ENV['OPENSHIFT_DATA_DIR'] ||= ''

if File.directory?(ENV['OPENSHIFT_DATA_DIR'])
  run Rack::URLMap.new( {
    "/binaries" => Rack::Directory.new(ENV['OPENSHIFT_DATA_DIR']),
    "/sources" => Rack::Directory.new(ENV['OPENSHIFT_DATA_DIR']),
    "/" => Rack::Jekyll.new(:no_render => true)
  })
else
  run Rack::Jekyll.new(:auto => false)
end

