module JsonLoader
  def load_json(path)
    json_content = load_fixture_file(path)
    JSON.parse(json_content).with_indifferent_access
  end

  private

  def load_fixture_file(path)
    full_path = Rails.root.join("spec/fixtures/#{path}").to_s
    File.read(full_path)
  end
end

RSpec.configure do |config|
  config.include JsonLoader
end
