module VcrResponseLoader
  def load_cassette_response(vcr_path)
    if ENV['RECORD_CASSETTES'] == 'true'
      puts "\n ⚠️ Recording cassettes mode is enabled, skipping response body verification." \
           'Make sure to run the suite again after recording cassettes to verify'
      anything
    else
      cassette = YAML.load_file("spec/vcr_cassettes/#{vcr_path}.yml")
      code = cassette.dig('http_interactions', 0, 'response', 'status', 'code')
      return { message: 'done' } if code == 204

      JSON.parse(cassette.dig('http_interactions', 0, 'response', 'body', 'string'))
    end
  end
end

RSpec.configure do |config|
  config.include VcrResponseLoader
end
