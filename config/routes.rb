Rails.application.routes.draw do
  devise_for :users

  root "dashboard#index"

  resources :operations
  resources :categories do
    resources :subcategories, only: [:create, :destroy]
  end

  get "extractions", to: "extractions#index"
  get "extractions/results", to: "extractions#results"

  get "subcategories_for_category/:category_id", to: "subcategories#for_category", as: :subcategories_for_category

  get "up" => "rails/health#show", as: :rails_health_check
end
