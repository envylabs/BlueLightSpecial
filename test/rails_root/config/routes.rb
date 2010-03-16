ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :users
  end
  map.resource :account
  map.root :controller => 'accounts', :action => 'edit'

  BlueLightSpecial::Routes.draw(map)
end
