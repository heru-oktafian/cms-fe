Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  post "contact-message", to: "pages#create_contact_message", as: :contact_message
  get "sections/:section", to: "pages#refresh_section", as: :refresh_section
end
