require "net/http"
require "json"

class CmsApiClient
  def initialize(base_url: ENV.fetch("CMS_BE_BASE_URL", "http://127.0.0.1:8080"))
    @base_url = base_url
  end

  def portfolio
    get_json("/api/v1/public/portfolio") || {}
  end

  def skills
    get_json("/api/v1/public/skills") || []
  end

  def projects
    get_json("/api/v1/public/projects") || []
  end

  def experiences
    get_json("/api/v1/public/experiences") || []
  end

  def social_links
    get_json("/api/v1/public/social-links") || []
  end

  def tools
    get_json("/api/v1/public/tools") || []
  end

  def profile
    get_json("/api/v1/public/profile") || {}
  end

  def create_contact_message(payload)
    post_json("/api/v1/public/contact-messages", payload)
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

  def post_json(path, body)
    uri = URI.parse("#{base_url}#{path}")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = body.to_json

    response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
    payload = JSON.parse(response.body) rescue {}

    {
      ok: response.code.to_i.between?(200, 299),
      status: response.code.to_i,
      data: payload["data"],
      message: payload["message"]
    }
  rescue StandardError => e
    Rails.logger.error("[cms-fe] POST #{path} failed: #{e.class}: #{e.message}")
    {
      ok: false,
      status: 500,
      data: nil,
      message: "Terjadi kesalahan saat mengirim pesan."
    }
  end
end
