Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only: [:index, :show] do
  		get "/word-pairs" => "word_pairs#index"
  		get "/word-pairs/:word_pair" => "word_pairs#show"
  end
end
