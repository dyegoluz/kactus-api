module Nerdify
    module Templates
        module AdminSession
            def self.included(subclass)
                super(subclass)
                subclass.class_eval do
                    page :new, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            model.nerdify.actions.select { |action| action.name.to_sym == :new   }.each do |action|
                                                component :form, id: "new_#{resource_symbol}", resource: :"#{resource_symbol}", submit: ((action || OpenStruct.new({ options: {} })).options[:submit] || { post: "..", data: { "#{resource_symbol}": ":resource" }, success: { redirect_to: "..", toast: :success }, error: { toast: :error, update: "components" } }), backend_if: action.options[:backend_if] do
                                                    model.nerdify.fieldsets.select { |ig| (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                                        self.page.controller.fieldset_or_field(child, self)
                                                    end

                                                    model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new") && (!action.options[:position].present? || action.options[:position].to_s == "body")  }.each do |action|
                                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: :secondary }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name},(object || #{model})") })
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    page :edit, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            model.nerdify.actions.select { |action| action.name.to_sym == :edit   }.each do |action|
                                                component :form, id: "edit_#{resource_symbol}", resource: :"#{resource_symbol}", submit: ((action || OpenStruct.new({ options: {} })).options[:submit] || { put: "..", data: { "#{resource_symbol}": ":resource" }, success: { redirect_to: "..", toast: :success }, error: { toast: :error, update: "components" } }), backend_if: action.options[:backend_if] do
                                                    model.nerdify.fieldsets.select { |ig| (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                                        self.page.controller.fieldset_or_field(child, self)
                                                    end

                                                    model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit") && (!action.options[:position].present? || action.options[:position].to_s == "body")  }.each do |action|
                                                        component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: :secondary }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name},(object || #{model})") })
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end



                    page :show, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :container, resource: :"#{resource_symbol}", size: 12 do
                                                model.nerdify.fieldsets.select { |ig| (!ig.options[:only] || ig.options[:only].include?(page.name.to_s)) }.each do |child|
                                                    self.page.controller.fieldset_or_field(child, self, { view: :viewonly, layout: :inside, label: true })
                                                end
                                            end

                                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("show")  }.each do |action|
                                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ position: :footer, styles: (action.options[:styles] || { background: :secondary }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name},(object || #{model})") })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end


                    page :index, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :container, name: :body, translate: false, styles: { vertical_align: { body: "top" } }  do
                                                if self.page.options[:layout].to_s == "embed"
                                                    model.nerdify.filters.each do |filter|
                                                        component :form, name: filter.name, resource: :filters, **{ size: 12, submit: { get: ".", data: { filters: ":resource" }, success: { update: "resources" } } }.merge(filter.options) do
                                                            filter.children.each do |child|
                                                                self.page.controller.fieldset_or_field(child, self)
                                                            end
                                                            model.nerdify.actions.select { |action| action.options[:only].include?("index") && action.options[:position].to_s == "header" }.each do |action|
                                                                component :button, name: :"#{action.name}_#{resource_symbol}", **{ styles: (action.options[:styles] || { background: :secondary, margin: { bottom: 2 } }), click: (action.options[:click] || { redirect_to: action.name, open_in: action.options[:open_in] }), backend_if: (action.options[:backend_if] || "can? :#{action.name},(object || #{model})") }.merge(**action.options.merge({ position: :right }))
                                                            end
                                                        end
                                                    end
                                                else
                                                    model.nerdify.filters.each do |filter|
                                                        component :form, name: filter.name, resource: :filters, **{ size: 12, styles: { margin: { top: 1, bottom: 1 }, padding: {} }, submit: { get: ".", data: { filters: ":resource" }, success: { update: "resources" } } }.merge(filter.options) do
                                                            filter.children.each do |child|
                                                                self.page.controller.fieldset_or_field(child, self)
                                                            end
                                                        end
                                                    end
                                                end

                                                model.nerdify.lists.each do |list|
                                                    case list.options[:type].to_s
                                                    when "cards"
                                                        component :list, name: list.name, resources: :"#{resource_symbol.to_s.pluralize}", **{ size: 12 }.merge(list.options) do
                                                            component :card, size: list.options[:card_size], click: list.options[:click_item] do
                                                                list.components.each do |c|
                                                                    self.page.controller.fieldset_or_field(c, self)
                                                                  # component (c.options[:component] || :input), name: c.name, **c.options.merge({label: false, view: :viewonly, layout: :inline})
                                                                end
                                                            end
                                                        end
                                                    when "calendar"
                                                        component :calendar, name: list.name, resources: :"#{resource_symbol.to_s.pluralize}", **{ size: 12 }.merge(list.options) do
                                                        end
                                                    when "kanban"
                                                        component :kanban, name: list.name, resources: :"#{resource_symbol.to_s.pluralize}", **{ size: 12 }.merge(list.options) do
                                                            component :card, size: list.options[:card_size], click: list.options[:click_item] do
                                                                list.components.each do |c|
                                                                    component (c.options[:component] || :input), name: c.name, **c.options.merge({ label: false, view: :viewonly, layout: :inline })
                                                                end
                                                            end
                                                        end
                                                    when "timeline"
                                                        component :timeline, name: list.name, resources: :"#{resource_symbol.to_s.pluralize}", **{ size: 12 }.merge(list.options) do
                                                            component :container, size: list.options[:card_size], click: list.options[:click_item] do
                                                                list.components.each do |c|
                                                                    component (c.options[:component] || :input), name: c.name, **c.options.merge({ label: false, view: :viewonly, layout: :inline })
                                                                end
                                                            end
                                                        end
                                                    when "table"
                                                        component :table, name: list.name, table_header: list.components.map { |c| c.name }, resources: :"#{resource_symbol.to_s.pluralize}", **{ size: 12, click_item: (list.options[:click_item]), styles: (list.options[:styles] || { rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 } }) }.merge(**list.options) do
                                                            if list.options[:thead]
                                                                component :table_head, position: :top do
                                                                    list.components.each do |column|
                                                                        component (column.options[:component] || :input), name: column.name, **column.options
                                                                    end
                                                                end
                                                            end
                                                            component :table_body do
                                                                list.components.each do |column|
                                                                    component (column.options[:component] || :input), name: column.name, **column.options.merge({ view: :viewonly, layout: :inline, label: false })
                                                                end
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end




                    page :new_session, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :form, id: "sign_in_#{resource_symbol}", resource: :"#{resource_symbol}", submit: { post: ".", data: { "#{resource_symbol}": { email: ":resource.email", password: ":resource.password" } }, success: { redirect_to: "../../:response.redirect_to", toast: :success }, error: { toast: :error, update: "components" } } do
                                                component :fieldset, name: :sign_in, header: true, size: 12 do
                                                    component :input, name: :email, input_type: :text, format: /[^@\s]+@[^@\s]+/, view: :editable, layout: :outside, label: true, size: 12
                                                    component :input, name: :password, input_type: :password, view: :editable, layout: :outside, label: true, size: 12
                                                end
                                                component :button, name: :"sign_in_#{resource_symbol}", styles: { background: :secondary, width: 100 }, size: 12, backend_if: "can? :new_session, #{model}"
                                            end
                                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new_session")  }.each do |action|
                                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: "transparent", color: "secondary" }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name}, #{model}") })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end


                    page :new_password, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, image_size: 5
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :form, id: "new_password_#{resource_symbol}", resource: :"#{resource_symbol}", submit: { post: "..", data: { "#{resource_symbol}": { email: ":resource.email" } }, success: { redirect_to: "../../sign_in", toast: :success }, error: { toast: :error, update: "components" } } do
                                                component :fieldset, name: :new_password, header: true, size: 12 do
                                                    component :input, name: :email, input_type: :text, format: /[^@\s]+@[^@\s]+/, view: :editable, layout: :outside, label: true, size: 12
                                                end
                                                component :button, name: :"new_password_#{resource_symbol}", styles: { background: :secondary, width: 100 }, size: 12, backend_if: "can? :new_password, #{model}"
                                            end
                                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("new_password")  }.each do |action|
                                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: "transparent", color: "secondary" }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name}, #{model}") })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    page :edit_password, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, styles: { margin: { top: 5 } }
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :form, id: "edit_password_#{resource_symbol}", resource: :"#{resource_symbol}", submit: { put: "..", data: { "#{resource_symbol}": { password: ":resource.password", password_confirmation: ":resource.password_confirmation", reset_password_token: ":resource.reset_password_token" } }, success: { redirect_to: "../../../:response.redirect_to", toast: :success }, error: { toast: :error, update: "components" } } do
                                                component :fieldset, name: :edit_password, header: true, size: 12 do
                                                    component :input, name: :password, input_type: :password, view: :editable, layout: :outside, label: true, size: 12
                                                    component :input, name: :password_confirmation, input_type: :password, view: :editable, layout: :outside, label: true, size: 12
                                                end
                                                component :button, name: :"edit_password_#{resource_symbol}", styles: { background: :secondary },  backend_if: "can? :edit_password, #{model}"
                                            end

                                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit_password")  }.each do |action|
                                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: "transparent", color: "secondary" }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name}, #{model}") })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end


                    page :edit_invitation, model: model, layout: "fullscreen" do
                        component :container, size: 12, styles: { display: "d-none d-md-block", height: 100, align: { body: "center" } } do
                            component :container, resource: :"#{resource_symbol}", styles: { height: 100, align: { body: "center" } } do
                                component :container, size: 10, resource: :"#{resource_symbol}", styles: { height: 100 } do
                                    component :card, resource: :"#{resource_symbol}", size: 12, styles: { orientation: { body: "horizontal" }, vertical_align: { body: "stretch" } } do
                                        component :container, size: 5, styles: { height: 100, background: "secondary", padding: { left: 3, top: 5, right: 3, bottom: 3 }, align: { body: "center" } } do
                                            component :image, name: :logo,  src: "assets/images/logo.png", static: true, styles: { margin: { top: 5 } }
                                        end

                                        component :container, resource: :"#{resource_symbol}", size: 7, styles: { padding: { left: 5, right: 5, bottom: 5, top: 5 }, margin: { left: 5, right: 5, bottom: 5, top: 5 } } do
                                            component :form, id: "edit_invitation_#{resource_symbol}", resource: :"#{resource_symbol}", submit: { put: "..", data: { "#{resource_symbol}": { password: ":resource.password", password_confirmation: ":resource.password_confirmation", invitation_token: ":resource.invitation_token" } }, success: { redirect_to: "../../../:response.redirect_to", toast: :success }, error: { toast: :error, update: "components" } } do
                                                component :fieldset, name: :edit_invitation, header: true, size: 12 do
                                                    component :input, name: :password, input_type: :password, view: :editable, layout: :outside, label: true, size: 12
                                                    component :input, name: :password_confirmation, input_type: :password, view: :editable, layout: :outside, label: true, size: 12
                                                end
                                                component :button, name: :"edit_invitation_#{resource_symbol}", styles: { background: :secondary }, backend_if: "can? :edit_invitation, #{model}"
                                            end
                                            model.nerdify.actions.select { |action| action.name.to_sym != :tutorial && action.options[:only].include?("edit_invitation")  }.each do |action|
                                                component :button, name: :"#{action.name}_#{resource_symbol}", **action.options.merge(**{ styles: (action.options[:styles] || { background: "transparent", color: "secondary" }), click: action.options[:click], backend_if: (action.options[:backend_if] || "can? :#{action.name}, #{model}") })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
