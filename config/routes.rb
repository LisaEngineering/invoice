Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'in'                 =>'invoice#in'
  get 'invoice/:id'        => 'list#invoice'

end
