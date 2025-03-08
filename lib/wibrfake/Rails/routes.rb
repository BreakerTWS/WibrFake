module WibrFake
    class Rails
        def self.routes(login, route)
            case login
            when 'basic'
                routes = [{sessions_get: "sessions#basic", as_get: :page_index}]
                routes << {
                    route: route,
                    sessions_get: "sessions#basic",
                    sessions_post: "sessions#basic_login",
                    as_get: "basic_login",
                    as_post: "basic_login_post"
                }
            when 'wifietecsa'
                routes = [{sessions_get: "sessions#nauta", as_get: :page_index}]
                routes << {
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