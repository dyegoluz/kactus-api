module Nerdify
    module Templates
        module Pages
            def self.included(subclass)
                super(subclass)
                subclass.class_eval do
                    # Página padrão index
                    # - TopBar se layout default
                    # - Menu fom Nerdify::Config::Menu
                    # - Menu fom Nerdify::Config::Menu
                    # - Actions only index e on header
                    # - Lista de dados (só tabelas por enquanto)


                    def self.controller_path
                        self.to_s.underscore
                    end

                    page :index, model: model,
                                i18n_layout: "#{subclass.to_s.underscore.pluralize}.index",
                                controller: subclass.to_s.underscore,
                                header: { container: true, class: "bg-info bg-header" },
                                filters: { container: true },
                                # tutorial_model: "TutorialStep",
                                body: { container: true, margin: { bottom: 4, top: 4 } },
                                footer: { container: true },
                                resources: { router: { app_search: "" } },
                                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "index" }; action.name.to_sym == :index && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
                        nerdify_action = model.nerdify.actions.select do |action|
                            action.name.to_sym == :index # && (!action.options[:backend_if].present? || eval(action.options[:backend_if]))
                        end.first

                        if self.options[:layout].to_s == "modal"
                            component :container, position: :header do
                                component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, static: true
                            end
                        end

                        if self.options[:layout].to_s == "default"
                            component :container, position: :header, size: 12, styles: {  color: "dark", align: { right: "horizontal" }, padding: { left: 5, top: 2, right: 5, bottom: 0 } } do
                                component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 5, position: :left, i18n_layout: true, click: { redirect_to: "/" }


                                component :container, position: :right, styles: { padding: { left: 0, top: 0, right: 0, bottom: 0 }, margin: { top: 1 } } do
                                    menu_path = "platform"
                                    nav_items = [
                                        {
                                            name: I18n.t("application.config.menu.site.home.name", default: "#home"),
                                            position: 0,
                                            label: I18n.t("application.config.menu.site.home.name", default: "home"),
                                            icon: I18n.t("application.config.menu.site.home.icon", default: "info"),
                                            path: "#home"
                                        },
                                        {
                                            name: I18n.t("application.config.menu.site.how.name", default: "#how"),
                                            position: 0,
                                            label: I18n.t("application.config.menu.site.how.name", default: "how works"),
                                            icon: I18n.t("application.config.menu.site.how.icon", default: "info"),
                                            path: "#home"
                                        },
                                        {
                                            name: I18n.t("application.config.menu.site.benefits.name", default: "#benefits"),
                                            position: 0,
                                            label: I18n.t("application.config.menu.site.benefits.name", default: "benefits"),
                                            icon: I18n.t("application.config.menu.site.benefits.icon", default: "info"),
                                            path: "#home"
                                        },
                                        {
                                            name: I18n.t("application.config.menu.site.user_area.name", default: "#user_area"),
                                            position: 0,
                                            label: I18n.t("application.config.menu.site.user_area.name", default: "user area"),
                                            icon: I18n.t("application.config.menu.site.user_area.icon", default: "info"),
                                            path: "/platform/subscriptions"
                                        }
                                    ]
                                    component :nav, name: :navigation, type: :pill, i18n_layout: true, styles: { color: "light", padding: { left: 0, top: 0, right: 0, bottom: 0 } }, items: nav_items
                                    component :button, name: :subscription, static: true, styles: { background: "secondary" }, click: { redirect_to: "/platform/subscriotions/new" }
                                end

                                component :container, position: :right, styles: { margin: { left: 2 }, padding: { left: 0, right: 0 } }, click: { redirect_to: "/integration/users/:resources.current_user.id", open_in: :dialog }, show_if: "this.page.resources.current_user" do
                                    component :html, name: :icon, resource: "current_user", show_if: "this.page.resources.current_user.icon"
                                  # component :text, type: :span, name: :name, resource: "current_user", styles: {color: "white", display: "d-none d-md-block"}, show_if: "this.page.resources.current_user.name"
                                end

                                component :container, position: :bottom, size: 12, styles: { padding: { top: 0, bottom: 0, left: 5, right: 5 }, margin: { top: 5, bottom: 5 } } do
                                    component :container, size: 6, resource: "setting", styles: { padding: { top: 4, bottom: 4, left: 0, right: 0 }, orientation: { body: "vertical" }, vertical_align: { body: "center" } }  do
                                        component :text, type: :h1, name: :header_title, styles: { font_weight: 5, color: "light" }
                                        component :text, type: :p, name: :header_description, styles: { font_size: 4, font_weight: 5, color: :light }
                                        component :button, name: :button_text, styles: { margin: { top: 3 }, background: "secondary" }, click: { redirect_to: "/platform/subscriptions/new" }
                                    end

                                    component :container, size: 6, resource: "setting", styles: { padding: { top: 4, bottom: 4, left: 5, right: 0 }, align: { body: "right" } } do
                                      component :image, name: :header_image_url
                                    end
                                end
                            end

                            component :container, resource: :setting, size: 12, styles: { orientation: { body: "vertical" }, align: { body: "center" }, padding: { top: 3, left: 5, right: 5, bottom: 3 }, margin: { top: 5, bottom: 5 } } do
                                component :container, size: 12, styles: { padding: { left: 5, right: 5 }, align: { body: "center" }, orientation: { body: "vertical" } } do
                                    component :text, type: :h2, name: :blocks_title, styles: { color: "primary", font_weight: 5, padding: { left: 5, right: 5 }, margin: { left: 5, right: 5 } }
                                    component :text, type: :p, name: :blocks_description, styles: { font_size: 4, padding: { left: 5, right: 5 }, margin: { left: 5, right: 5, bottom: 3 } }
                                end

                                component :container, size: 12, styles: { vertical_align: { body: "top" }, padding: { top: 3 } } do
                                    component :card, size: 4, styles: { orientation: { body: "vertical" }, align: { body: "center" }, padding: { left: 5, right: 5, top: 5, bottom: 5 } } do
                                        component :image, name: :first_image_url, image_size: 3
                                        component :text, type: :h3, name: :first_title, styles: { margin: { top: 2, bottom: 2 }, font_weight: 5 }
                                        component :text, type: :p, name: :first_description, styles: { font_size: 4 }
                                    end

                                    component :card, size: 4, styles: { orientation: { body: "vertical" }, align: { body: "center" }, padding: { left: 5, right: 5, top: 5, bottom: 5 } } do
                                        component :image, name: :second_image_url, image_size: 3
                                        component :text, type: :h3, name: :second_title, styles: { margin: { top: 2, bottom: 2 }, font_weight: 5 }
                                        component :text, type: :p, name: :second_description, styles: { font_size: 4 }
                                    end

                                    component :card, size: 4, styles: { orientation: { body: "vertical" }, align: { body: "center" }, padding: { left: 5, right: 5, top: 5, bottom: 5 } } do
                                        component :image, name: :third_image_url, image_size: 3
                                        component :text, type: :h3, name: :third_title, styles: { margin: { top: 2, bottom: 2 }, font_weight: 5 }
                                        component :text, type: :p, name: :third_description, styles: { font_size: 4 }
                                    end
                                end

                                component :container, position: :bottom, size: 12, styles: { padding: { top: 0, bottom: 0, left: 5, right: 5 }, margin: { top: 5, bottom: 5 } } do
                                    component :container, size: 6, resource: "setting", styles: { padding: { top: 4, bottom: 4, left: 5, right: 0 }, align: { body: "right" } } do
                                      component :image, name: :highlight_image_url, styles: { padding: { left: 5, top: 5, right: 5, bottom: 5 } }
                                    end

                                    component :container, size: 6, resource: "setting", styles: { padding: { top: 4, bottom: 4, left: 0, right: 0 }, orientation: { body: "vertical" }, vertical_align: { body: "center" } }  do
                                        component :text, type: :h3, name: :highlight_title, styles: { color: :primary, font_weight: 5 }
                                        component :text, type: :p, name: :highlight_description, styles: { font_size: 4 }
                                        component :list, resources: "highlight_items_list", styles: { margin: { top: 3 } } do
                                            component :card, size: 12 do
                                                component :icon, name: :check_circle, styles: { color: :secondary }, position: :left, static: true
                                                component :text, type: :span, name: :text
                                            end
                                        end
                                        component :button, type: :warning, name: :highlight_button_text, styles: { margin: { top: 3 } }, click: { redirect_to: "/platform/subscriptions/new" }
                                    end
                                end
                            end

                            component :container, size: 12, styles: { background: "primary", color: "white", padding: { left: 3, bottom: 3, right: 3, top: 3 }, rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 }  } do
                                component :container, position: :left, styles: { padding: {}, margin: {}, orientation: { body: "vertical" }, vertical_align: { body: "center" } } do
                                    component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 4
                                end

                                component :container, position: :right, styles: { orientation: { body: "horizontal" }, padding: {}, margin: {} } do
                                   component :container, styles: { align: { body: "right" }, padding: {}, margin: {} } do
                                        component :icon, name: :phone, styles: { color: :secondary }
                                        component :text, type: :span, name: :text, static: true, position: :right, styles: { color: "white" }
                                   end

                                   component :container, styles: { align: { body: "right" }, padding: {}, margin: {} } do
                                        component :icon, name: :alternate_email, styles: { color: :secondary }
                                        component :text, type: :span, name: :text, static: true, position: :right, styles: { color: "white" }
                                   end

                                   component :container, styles: { align: { body: "right" }, padding: {}, margin: {} } do
                                        component :icon, name: :place, styles: { color: :secondary }
                                        component :text, type: :span, name: :text, static: true, position: :right, styles: { color: "white" }
                                   end
                                end

                                component :container, size: 12, styles: { orientation: { body: "vertical" }, align: { body: "center" }, padding: {}, margin: {} } do
                                    component :text, type: :p, name: :footer_description, static: true, styles: { color: "white" }
                                    component :text, type: :small, name: :footer_copyright, static: true, styles: { color: "white" }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
