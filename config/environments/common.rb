Mtheory::Application.configure do
  if defined?(::WEBrick) or Rails.env['SERVER_SOFWTARE'] =~ /webrick/
    Mtheory::DecksterConfiguration.streaming = false
    config.cache_classes = false
    config.eager_load = false
  else
    Mtheory::DecksterConfiguration.streaming = true
    config.cache_classes = true
    config.eager_load = true
  end
end