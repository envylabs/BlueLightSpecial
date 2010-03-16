module BlueLightSpecial
  class Routes

    # In your application's config/routes.rb, draw BlueLightSpecial's routes:
    #
    # @example
    #   map.resources :posts
    #   BlueLightSpecial::Routes.draw(map)
    #
    # If you need to override a BlueLightSpecial route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   BlueLightSpecial::Routes.draw(map)
    def self.draw(map)
      map.resources :passwords,
        :controller => 'blue_light_special/passwords',
        :only       => [:new, :create]

      map.resource  :session,
        :controller => 'blue_light_special/sessions',
        :only       => [:new, :create, :destroy]

      map.resources :users, :controller => 'blue_light_special/users' do |users|
        users.resource :password,
          :controller => 'blue_light_special/passwords',
          :only       => [:create, :edit, :update]
      end
      
      map.resource  :impersonation,
        :controller => 'blue_light_special/impersonations',
        :only       => [:create, :destroy]
      
      map.sign_up    'sign_up',
        :controller   => 'blue_light_special/users',
        :action       => 'new'
      map.sign_in    'sign_in',
        :controller   => 'blue_light_special/sessions',
        :action       => 'new'
      map.fb_connect 'fb_connect',
        :controller   => 'blue_light_special/sessions',
        :action       => 'create'
      map.sign_out   'sign_out',
        :controller   => 'blue_light_special/sessions',
        :action       => 'destroy',
        :method       => :delete
    end

  end
end
