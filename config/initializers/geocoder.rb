Geocoder.configure(

  # geocoding service (see below for supported options):
  :lookup => :google,

  # IP address geocoding service (see below for supported options):
  :ip_lookup => :freegeoip,

  # to use an API key:
  # :api_key => "",

  # geocoding service request timeout, in seconds (default 3):
  :timeout => 20,

  # set default units to kilometers:
  :units => :mi,

  # caching (see below for details):
  :cache => Rails.cache
  # :cache_prefix => "..."

)
