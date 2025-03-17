module WibrFake
    class Rails
        def self.usage(route: nil)
            routes = {
                    route: route,
                    route_about: "#{route}/about",
                    sessions_get: "sessions#wibrfake",
                    sessions_get_about: "sessions#wibrfake_about",
                }
        end
        def self.routes(login: nil, route: nil)
            case login
            when 'basic'
                routes = [{sessions_get: "sessions#basic", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#basic",
                    sessions_post: "sessions#basic_login",
                    as_get: "basic_login",
                    as_post: "basic_login_post"
                }
            when 'nauta_etecsa'
                routes = [{sessions_get: "sessions#nauta_etecsa", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#nauta_etecsa",
                    sessions_post: "sessions#nauta_etecsa_login",
                    as_get: "nauta_etecsa_login",
                    as_post: "nauta_etecsa_login_post"
                }
            when 'nauta_hogar'
                routes = [{sessions_get: "sessions#nauta_hogar", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#nauta_hogar",
                    sessions_post: "sessions#nauta_hogar_login",
                    as_get: "nauta_hogar_login",
                    as_post: "nauta_hogar_login_post"
                }
            when 'facebook'
                routes = [{sessions_get: "sessions#facebook", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#facebook",
                    sessions_post: "sessions#facebook_login",
                    as_get: "facebook_login",
                    as_post: "facebook_login_post"
                }
            when 'instagram'
                routes = [{sessions_get: "sessions#instagram", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#instagram",
                    sessions_post: "sessions#instagram_login",
                    as_get: "instagram_login",
                    as_post: "instagram_login_post"
                }
            when 'google'
                routes = [{sessions_get: "sessions#google", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route_login: route,
                    sessions_get: "sessions#google",
                    sessions_post: "sessions#google_login",
                    as_get: "google_login",
                    as_post: "google_login_post"
                }
            end
        end
    end
end