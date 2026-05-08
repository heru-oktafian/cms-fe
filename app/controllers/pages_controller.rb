class PagesController < ApplicationController
  def home
    client = CmsApiClient.new
    @profile = client.profile || {}
    @skills = client.skills || []
    @tools = client.tools || []
    @projects = client.projects || []
    @skills_by_category = @skills.group_by { |skill| skill["category"].presence || "Others" }
  end
end
