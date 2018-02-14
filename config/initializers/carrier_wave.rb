=begin
class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    true
  end
end
=end

CarrierWave.configure do |config|
  config.cache_dir = Rails.root.join 'tmp/uploads'
=begin
  if Rails.env.development? || Rails.env.production?
    config.storage :file
  elsif Rails.env.test?
    config.strage NullStorage
  end
=end
end