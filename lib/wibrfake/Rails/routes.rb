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
            when 'wifietecsa'
                routes = [{sessions_get: "sessions#nauta", as_get: :page_index}]
                routes << {
                    route_generate_204: 'generate_204/',
                    route: route,
                    sessions_get: "sessions#nauta",
                    sessions_post: "sessions#nauta_login",
                    as_get: "nauta_login",
                    as_post: "nauta_login_post"
                }
            end
        end
    end
end