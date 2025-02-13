module WibrFake
    class Rails
        def self.routes(login, route)
            routes = [{sessions_get: "sessions#index", as_get: :page_index}]
            case login
            when 'basic'
                routes << {
                    route: route,
                    sessions_get: "sessions#basic",
                    sessions_post: "sessions#basic_login",
                    as_get: "basic_login",
                    as_post: "basic_login_post"
                }
            end
        end
    end
end