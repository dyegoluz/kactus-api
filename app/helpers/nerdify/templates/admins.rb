module Nerdify
    module Templates
        module Admins
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
                                header: { container: true, class: "bg-primary" },
                                filters: { container: true },
                                # tutorial_model: "TutorialStep",
                                body: { container: true, margin: { bottom: 4, top: 4 } },
                                footer: { container: true },
                                resources: { router: { app_search: "" } },
                                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "index" }; action.name.to_sym == :index && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
                        nerdify_action = model.nerdify.actions.select do |action|
                            action.name.to_sym == :index && (!action.options[:backend_if].present? || eval(action.options[:backend_if]))
                        end.first

                        if self.options[:layout].to_s == "modal"
                            component :container, position: :header do
                                component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, static: true
                            end
                        end

                        if self.options[:layout].to_s == "default"
                            component :container, position: :header, size: 12, styles: { background: :primary, color: :white, border_color: :primary, align: { right: "horizontal" }, padding: { left: 1, top: 2, right: 1, bottom: 0 } } do
                                component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 5, position: :left, i18n_layout: true, click: { redirect_to: "/" }


                                component :container, position: :right, styles: { padding: { left: 0, top: 0, right: 0, bottom: 0 }, margin: { top: 1 } } do
                                    menu_path = "admin"
                                    nav_items = Nerdify::Config::Menu.new.file_links(menu_path)
                                    component :nav, name: :navigation, i18n_layout: true, styles: { color: "white", padding: { left: 0, top: 0, right: 0, bottom: 0 } }, items: nav_items
                                end

                                component :container, position: :right, styles: { margin: { left: 2 }, padding: { left: 0, right: 0 } }, click: { redirect_to: "/integration/users/:resources.current_user.id", open_in: :dialog }, show_if: "this.page.resources.current_user" do
                                    component :html, name: :icon, resource: "current_user", show_if: "this.page.resources.current_user.icon"
                                  # component :text, type: :span, name: :name, resource: "current_user", styles: {color: "white", display: "d-none d-md-block"}, show_if: "this.page.resources.current_user.name"
                                end
                            end

                            if !self.options[:without_page_header]
                                component :container do
                                    component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, size: 12, static: true, i18n: "#{resource_symbol.to_s.humanize}"
                                    component :text, name: :"#{resource_symbol}_#{page.name}_help", type: :p, size: 12, static: true, i18n: "List of registered #{resource_symbol.to_s.humanize}"

                                    model.nerdify.actions.select { |action| action.name.to_sym == :tutorial && action.options[:only].include?("index") }.each do |action|
                                        component :button, name: :tutorial, static: true, position: :right, styles: { background: "transparent", color: "primary" }, i18n_layout: true, click: { tutorial: true }, only_icon_on_mobile: true, backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))")
                                    end

                                    model.nerdify.actions.select { |action| action.name.to_sym == :index }.each do |action|
                                        if action.options[:lists].present?
                                            component :list_types, static: true, position: :right, lists: action.options[:lists], backend_if: action.options[:backend_if]
                                        end
                                    end

                                    model.nerdify.actions.select { |action| action.options[:only].include?("index") && action.options[:position].to_s == "header" }.each do |action|
                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: :right, styles: (action.options[:styles] || { background: :primary }), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }), only_icon_on_mobile: true
                                    end
                                end
                            end
                        end

                        component :container, name: :body, translate: false, styles: { vertical_align: { body: "top" } }  do
                            if self.page.options[:layout].to_s == "embed"
                                model.nerdify.filters.each do |filter|
                                    component :filters, name: filter.name, resource: :filters, **{ size: 12, submit: { get: ".", data: { filters: ":resource" }, success: { update: "resources" } } }.merge(filter.options) do
                                        filter.children.each do |child|
                                            self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                                        end
                                        model.nerdify.actions.select { |action| action.options[:only].include?("index") && action.options[:position].to_s == "header" }.each do |action|
                                            component :button, name: :"#{action.name}_#{resource_symbol}", **{ styles: (action.options[:styles] || { background: :primary, margin: { bottom: 2 } }), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }.merge(**action.options.merge({ position: :right }))
                                        end
                                    end
                                end
                            else
                                model.nerdify.filters.each do |filter|
                                    component :filters, name: filter.name, resource: :filters, **{ size: 12, styles: { margin: { top: 1, bottom: 1 }, padding: {} }, submit: { get: ".", data: { filters: ":resource" }, success: { update: "resources" } } }.merge(filter.options) do
                                        filter.children.each do |child|
                                            self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                                        end
                                    end
                                end
                            end

                            list_actions = model.nerdify.actions.select { |action| action.options[:only].include?("index") && action.options[:on].to_s == "member" }.map(&:to_h)

                            model.nerdify.lists.each do |list|
                                self.page.controller.list_component(list, self)
                            end
                        end

                        component :container, size: 12,  resource: :"#{resource_symbol}", position: :footer, styles: { padding: {} } do
                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "body" }.each do |child|
                              self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "left" }.each do |child|
                              component :container, styles: {}, position: :left, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "right" }.each do |child|
                              component :container, styles: {}, position: :right, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("index") && action.options[:position].to_s == "footer" && (!action.options[:footer] || action.options[:footer] == "body")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: action.options[:footer] || "body", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("index") && action.options[:position].to_s == "footer" && (action.options[:footer] == "right")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "right", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("index") && action.options[:position].to_s == "footer" && (action.options[:footer] == "left")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "left", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end
                        end
                    end

                    # Página padrão new
                    # - TopBar se layout default
                    # - Menu fom Nerdify::Config::Menu
                    # - Menu fom Nerdify::Config::Menu
                    # - Actions only index e on header
                    # - Lista de dados (só tabelas por enquanto)
                    page :new, model: model,
                                i18n_layout: "#{subclass.to_s.underscore.pluralize}.new",
                                header: { container: true, class: "bg-primary" },
                                filters: { container: true },
                                # tutorial_model: "TutorialStep",
                                resources: { router: { app_search: "" } },
                                body: { container: true, margin: { bottom: 4, top: 4 } },
                                footer: { container: true },
                                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "new" }; action.name.to_sym == :new && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
                        nerdify_action = model.nerdify.actions.select do |action|
                            action.name.to_sym == :new && (!action.options[:backend_if].present? || eval(action.options[:backend_if]))
                        end.first

                        if self.options[:layout].to_s == "modal"
                            component :container, position: :header do
                                component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, static: true
                            end
                        end

                        if self.options[:layout].to_s == "default"
                            component :container, position: :header, size: 12, styles: { background: :primary, color: :white, border_color: :primary, align: { right: "horizontal" }, padding: { left: 1, top: 2, right: 1, bottom: 0 } } do
                                component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 5, position: :left, i18n_layout: true, click: { redirect_to: "/" }


                                component :container, position: :right, styles: { padding: { left: 0, top: 0, right: 0, bottom: 0 }, margin: { top: 1 } } do
                                    menu_path = "admin"
                                    nav_items = Nerdify::Config::Menu.new.file_links(menu_path)
                                    component :nav, name: :navigation, i18n_layout: true, styles: { color: "white", padding: { left: 0, top: 0, right: 0, bottom: 0 } }, items: nav_items
                                end

                                component :container, position: :right, styles: { margin: { left: 2 }, padding: { left: 0, right: 0 } }, click: { redirect_to: "/integration/users/:resources.current_user.id", open_in: :dialog }, show_if: "this.page.resources.current_user" do
                                    component :html, name: :icon, resource: "current_user", show_if: "this.page.resources.current_user.icon"
                                  # component :text, type: :span, name: :name, resource: "current_user", styles: {color: "white", display: "d-none d-md-block"}, show_if: "this.page.resources.current_user.name"
                                end
                            end
                            if !self.options[:without_page_header]
                                component :container do
                                    component :text, name: :"#{resource_symbol}_#{page.name}", type: :h3, size: 12, static: true
                                    component :text, name: :"#{resource_symbol}_#{page.name}_help", type: :p, size: 12, static: true

                                    model.nerdify.actions.select { |action| action.name.to_sym == :tutorial && action.options[:only].include?("new") }.each do |action|
                                        component :button, name: :tutorial, static: true, position: :right, styles: { background: "transparent", color: "primary" }, i18n_layout: true, click: { tutorial: true }, only_icon_on_mobile: true, backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))")
                                    end

                                    model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && action.options[:position].to_s == "header" }.each do |action|
                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: :right, styles: (action.options[:styles] || { background: :primary }), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }), only_icon_on_mobile: true
                                    end
                                end
                            end
                        end

                        model.nerdify.actions.select { |action| action.name.to_sym == :new && action.options[:page]   }.each do |action|
                            component :form, id: "new_#{resource_symbol}", resource: :"#{resource_symbol}", submit: ((action || OpenStruct.new({ options: {} })).options[:submit]), backend_if: action.options[:backend_if] do
                                model.nerdify.fieldsets.select { |ig| ig.options[:footer].blank? && (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                    self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                                end

                                model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && (!action.options[:position].present? || action.options[:position].to_s == "body")  }.each do |action|
                                    component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") })
                                end
                            end
                        end


                        component :container, size: 12, resource: :"#{resource_symbol}", position: :footer do
                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "body" }.each do |child|
                              self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "left" }.each do |child|
                              component :container, styles: {}, position: :left, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "right" }.each do |child|
                              component :container, styles: {}, position: :right, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && action.options[:position].to_s == "footer" && (!action.options[:footer] || action.options[:footer] == "body")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: action.options[:footer] || "body", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && action.options[:position].to_s == "footer" && (action.options[:footer] == "right")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "right", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && action.options[:position].to_s == "footer" && (action.options[:footer] == "left")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "left", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end
                        end
                    end

                    # Editar padrão
                    # - TopBar se layout default
                    # - Menu fom Nerdify::Config::Menu
                    # - Menu fom Nerdify::Config::Menu
                    # - Actions only edit e on header
                    # - Lista de dados (só tabelas por enquanto)
                    page :edit, model: model,
                                i18n_layout: "#{subclass.to_s.underscore.pluralize}.edit",
                                header: { container: true, class: "bg-primary" },
                                filters: { container: true },
                                # tutorial_model: "TutorialStep",
                                resources: { router: { app_search: "" } },
                                body: { container: true, margin: { bottom: 4, top: 4 } },
                                footer: { container: true },
                                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "edit" }; action.name.to_sym == :edit && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
                        nerdify_action = model.nerdify.actions.select do |action|
                            action.name.to_sym == :edit && (!action.options[:backend_if].present? || eval(action.options[:backend_if]))
                        end.first

                        if self.options[:layout].to_s == "modal"
                            component :container, position: :header do
                                component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, static: true
                            end
                        end

                        if self.options[:layout].to_s == "default"
                            component :container, position: :header, size: 12, styles: { background: :primary, color: :white, border_color: :primary, align: { right: "horizontal" }, padding: { left: 1, top: 2, right: 1, bottom: 0 } } do
                                component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 5, position: :left, i18n_layout: true, click: { redirect_to: "/" }


                                component :container, position: :right, styles: { padding: { left: 0, top: 0, right: 0, bottom: 0 }, margin: { top: 1 } } do
                                    menu_path = "admin"
                                    nav_items = Nerdify::Config::Menu.new.file_links(menu_path)
                                    component :nav, name: :navigation, i18n_layout: true, styles: { color: "white", padding: { left: 0, top: 0, right: 0, bottom: 0 } }, items: nav_items
                                end

                                component :container, position: :right, styles: { margin: { left: 2 }, padding: { left: 0, right: 0 } }, click: { redirect_to: "/integration/users/:resources.current_user.id", open_in: :dialog }, show_if: "this.page.resources.current_user" do
                                    component :html, name: :icon, resource: "current_user", show_if: "this.page.resources.current_user.icon"
                                  # component :text, type: :span, name: :name, resource: "current_user", styles: {color: "white", display: "d-none d-md-block"}, show_if: "this.page.resources.current_user.name"
                                end
                            end
                            if !self.options[:without_page_header]
                                component :container do
                                    component :text, name: :"#{resource_symbol}_#{page.name}", type: :h3, size: 12, static: true
                                    component :text, name: :"#{resource_symbol}_#{page.name}_help", type: :p, size: 12, static: true

                                    model.nerdify.actions.select { |action| action.name.to_sym == :tutorial && action.options[:only].include?("edit") }.each  do |action|
                                       component :button, name: :tutorial, static: true, position: :right, styles: { background: "transparent", color: "primary" }, i18n_layout: true, click: { tutorial: true }, only_icon_on_mobile: true, backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))")
                                    end

                                    model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && action.options[:position].to_s == "header" }.each do |action|
                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: :right, styles: (action.options[:styles] || { background: :primary }), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }), only_icon_on_mobile: true
                                    end
                                end
                            end
                        end

                        model.nerdify.actions.select { |action| action.name.to_sym == :edit && action.options[:page]   }.each do |action|
                            component :form, id: "edit_#{resource_symbol}", resource: :"#{resource_symbol}", submit: ((action || OpenStruct.new({ options: {} })).options[:submit]), backend_if: action.options[:backend_if] do
                                model.nerdify.fieldsets.select { |ig| ig.options[:footer].blank? && ig.options[:position].to_s != "footer" && (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                    self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                                end

                                model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && (!action.options[:position].present? || action.options[:position].to_s == "body")  }.each do |action|
                                    component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") })
                                end
                            end
                        end

                        component :container, size: 12, resource: :"#{resource_symbol}", position: :footer do
                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "body" }.each do |child|
                              self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "left" }.each do |child|
                              component :container, styles: {}, position: :left, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "right" }.each do |child|
                              component :container, styles: {}, position: :right, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && action.options[:position].to_s == "footer" && (!action.options[:footer] || action.options[:footer] == "body")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: action.options[:footer] || "body", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && action.options[:position].to_s == "footer" && (action.options[:footer] == "right")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "right", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && action.options[:position].to_s == "footer" && (action.options[:footer] == "left")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "left", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end
                        end
                    end



                    # Editar padrão
                    # - TopBar se layout default
                    # - Menu fom Nerdify::Config::Menu
                    # - Menu fom Nerdify::Config::Menu
                    # - Actions only edit e on header
                    # - Lista de dados (só tabelas por enquanto)
                    page :show, model: model,
                                i18n_layout: "#{subclass.to_s.underscore.pluralize}.show",
                                header: { container: true, class: "bg-primary" },
                                filters: { container: true },
                                # tutorial_model: "TutorialStep",
                                resources: { router: { app_search: "" } },
                                body: { container: true, margin: { bottom: 5, top: 5 } },
                                footer: { container: true },
                                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "show" }; action.name.to_sym == :show && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
                        nerdify_action = model.nerdify.actions.select do |action|
                            action.name.to_sym == :show && (!action.options[:backend_if].present? || eval(action.options[:backend_if]))
                        end.first

                        if self.options[:layout].to_s == "modal"
                            component :container, position: :header do
                                component :text, name: :"#{resource_symbol}_#{page.name}_title", type: :h3, static: true
                            end
                        end

                        if self.options[:layout].to_s == "default"
                            component :container, position: :header, size: 12, styles: { background: :primary, color: :white, border_color: :primary, align: { right: "horizontal" }, padding: { left: 1, top: 2, right: 1, bottom: 0 } } do
                                component :image, name: :logo, src: "assets/images/logo.png", static: true, image_size: 5, position: :left, i18n_layout: true, click: { redirect_to: "/" }


                                component :container, position: :right, styles: { padding: { left: 0, top: 0, right: 0, bottom: 0 }, margin: { top: 1 } } do
                                    menu_path = "admin"
                                    nav_items = Nerdify::Config::Menu.new.file_links(menu_path)
                                    component :nav, name: :navigation, i18n_layout: true, styles: { color: "white", padding: { left: 0, top: 0, right: 0, bottom: 0 } }, items: nav_items
                                end

                                component :container, position: :right, styles: { margin: { left: 2 }, padding: { left: 0, right: 0 } }, click: { redirect_to: "/integration/users/:resources.current_user.id", open_in: :dialog }, show_if: "this.page.resources.current_user" do
                                    component :html, name: :icon, resource: "current_user", show_if: "this.page.resources.current_user.icon"
                                  # component :text, type: :span, name: :name, resource: "current_user", styles: {color: "white", display: "d-none d-md-block"}, show_if: "this.page.resources.current_user.name"
                                end
                            end

                            if !self.options[:without_page_header]
                                component :container do
                                    component :text, name: :"#{resource_symbol}_#{page.name}", type: :h3, size: 12, static: true
                                    component :text, name: :"#{resource_symbol}_#{page.name}_help", type: :p, size: 12, static: true

                                    model.nerdify.actions.select { |action| action.name.to_sym == :tutorial && action.options[:only].include?("show") }.each  do |action|
                                        component :button, name: :tutorial, static: true, position: :right, i18n_layout: true, click: { tutorial: true }, only_icon_on_mobile: true, backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))")
                                    end

                                    model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("show") && action.options[:position].to_s == "header" }.each do |action|
                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: :right, styles: (action.options[:styles]), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }), only_icon_on_mobile: true
                                    end
                                end
                            end
                        end

                        component :container, resource: :"#{resource_symbol}", size: 12 do
                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].blank? && (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                self.page.controller.fieldset_or_field(child, self, { view: :viewonly, layout: :inside, label: true }, nerdify_action)
                            end
                        end

                        component :container, size: 12,  resource: :"#{resource_symbol}", position: :footer do
                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "body" }.each do |child|
                              self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "left" }.each do |child|
                              component :container, styles: {}, position: :left, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.fieldsets.select { |ig| ig.options[:footer].to_s == "right" }.each do |child|
                              component :container, styles: {}, position: :right, resource: :"#{resource_symbol}" do
                                self.page.controller.fieldset_or_field(child, self, nil, nerdify_action)
                              end
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("show") && action.options[:position].to_s == "footer" && (!action.options[:footer] || action.options[:footer] == "body")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: action.options[:footer] || "body", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("show") && action.options[:position].to_s == "footer" && (action.options[:footer] == "right")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "right", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end

                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("show") && action.options[:position].to_s == "footer" && (action.options[:footer] == "left")  }.each do |action|
                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: "left", styles: (action.options[:styles] || { background: :primary }), click: action.options[:click], backend_if: ((action.options[:backend_if] || "true") + " && can?(:#{action.name},(object || #{model}))") }).merge({ position: "right" })
                            end
                        end
                    end
                end
            end
        end
    end
end
