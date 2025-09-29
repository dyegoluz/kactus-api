CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => "DO00ZENTHTNMAPUNBDLA",
    :aws_secret_access_key  => "T2MUNvRWOfjMLTKx1ed5M0QOUNkuwNzOT45lU7uiZww",
    :region                 => 'nyc3',
    #:host                   => 's3.example.com',
    :endpoint               => 'https://nyc3.digitaloceanspaces.com'
  }
  config.fog_directory  = "kactushub"
  config.fog_public    = true
end