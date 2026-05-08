require "net/http"
require "json"

class CmsApiClient
  def initialize(base_url: ENV.fetch("CMS_BE_BASE_URL", "http://127.0.0.1:8080"))
    @base_url = base_url
  end

  def profile
    get_json("/api/v1/public/profile")
  end

  def skills
    get_json("/api/v1/public/skills") || []
  end

  def tools
    get_json("/api/v1/public/tools") || []
  end

  def projects
    get_json("/api/v1/public/projects") || []
  end

  def experiences
    get_json("/api/v1/public/experiences") || []
  end

  private

  attr_reader :base_url

  def get_json(path)
    uri = URI.parse("#{base_url}#{path}")
    response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(Net::HTTP::Get.new(uri)) }
    return nil unless response.code.to_i.between?(200, 299)

    payload = JSON.parse(response.body)
    payload["data"]
  rescue StandardError => e
    Rails.logger.error("[cms-fe] GET #{path} failed: #{e.class}: #{e.message}")
    nil
  end
end
