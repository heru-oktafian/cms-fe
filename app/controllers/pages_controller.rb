class PagesController < ApplicationController
  SECTION_PARTIALS = {
    "skills" => "skills",
    "tools" => "tools",
    "projects" => "projects",
    "experiences" => "experiences",
    "contact" => "contact",
    "footer" => "footer"
  }.freeze

  def home
    client = CmsApiClient.new
    hydrate_homepage_data(client)
    @contact_form = default_contact_form
  end

  def create_contact_message
    client = CmsApiClient.new
    result = client.create_contact_message(contact_message_params)

    if result[:ok]
      redirect_to root_path(anchor: "contact"), notice: "Pesan berhasil dikirim. Terima kasih sudah menghubungi saya."
    else
      hydrate_homepage_data(client)
      @contact_form = default_contact_form.merge(contact_message_params)
      flash.now[:alert] = result[:message].presence || "Pesan gagal dikirim. Silakan coba lagi."
      render :home, status: :unprocessable_entity
    end
  end

  def refresh_section
    section = params[:section].to_s
    partial_name = SECTION_PARTIALS[section]
    return head :not_found unless partial_name

    client = CmsApiClient.new
    hydrate_homepage_data(client)
    @contact_form = default_contact_form

    html = render_to_string(partial: "pages/#{partial_name}", formats: [ :html ], layout: false)
    render json: { section: section, html: html }
  end

  private

  def hydrate_homepage_data(client)
    portfolio = client.portfolio || {}

    @profile = portfolio["profile"] || {}
    @skills = portfolio["skills"] || []
    @tools = portfolio["tools"] || []
    @projects = portfolio["projects"] || []
    @experiences = portfolio["experiences"] || []
    @social_links = portfolio["social_links"] || []
    @skills_by_category = @skills.group_by { |skill| skill["category"].presence || "Others" }
  end

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :phone, :subject, :message).to_h.transform_values { |value| value.to_s.strip }
  end

  def default_contact_form
    {
      "name" => "",
      "email" => "",
      "phone" => "",
      "subject" => "",
      "message" => ""
    }
  end
end
