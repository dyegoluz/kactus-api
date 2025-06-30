CarrierWave.configure do |config|
  if ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_KEY'] && ENV['AWS_S3_BUCKET']
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],
      #:region                 => 'sa-east-1',
      #:host                   => 's3.example.com',
      #:endpoint               => 'https://s3.example.com:8080'
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET']
  end
end
