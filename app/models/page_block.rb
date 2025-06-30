class PageBlock
  include Nerdify::Model
  orm :mongoid

  @@fieldset_styles = {margin: {}, padding: {}, border: {}, background: "transparent"}
  @@types = %w[text button video photo photos chart nav form]
  @@text_types = %w[h1 h2 h3 h4 h5 h6 p span small]
  @@chart_types = %w[pie bar line doughnut]
  @@styles_options = %w[0 1 2 3 4 5]
  @@positions = %w[body top right bottom left header footer]
  @@styles_colors = %w[primary secondary success danger warning info light dark transparent]
  @@styles_opacities = %w[0 25 50 75 100]
  @@styles_orientation = %w[vertical horizontal]
  @@styles_vertical_align = %w[top center bottom stretch]
  @@styles_align = %w[left center right]
  @@styles_sizes = %w[1 2 3 4 5 6 7 8 9 10 11 12]

  action :index
  action :show, layout: :modal
  action :cancel, only: %w(edit new), on: :member, position: :footer, click: {close: :dialog}, styles: {background: "transparent", color: :primary}
  action :edit, only: %w(show), on: :member, position: :footer, layout: :modal, click: {redirect_to: "edit", open_in: :dialog}, submit: {put: "..", data: {:page_block => ":resource"}, success: {redirect_to: "..", open_in: :dialog, toast: :success}, error: {toast: :error, update: "components"}}
  action :update, only: %w(edit), on: :member,position: :footer, click: {submit: "edit_page_block"}
  action :new, only: %w(index), on: :collection, position: :header, layout: :modal, click: {redirect_to: "new", open_in: :dialog}, submit: {post: "..", data: {:page_block =>  ":resource"}, success: {close: :dialog, update: "refresh", toast: :success}, error: {toast: :error, update: "components"}}
  action :create, only: %w(new), on: :member,position: :footer, click: {submit: "new_page_block"}
  action :destroy, only: %w(show), on: :member,position: :footer, layout: :modal, click: {delete: ".", confirm: true, success: {close: :dialog, update: "refresh", toast: :success}, error: {toast: :error}}
  action :sort, only: %w(), on: :collection, method: :post

  action :open, only: %w[index], on: :member, position: :dropdown, click: {redirect_to: ":resource.id", open_in: :dialog}
  action :add_children, only: %w[index], on: :member, position: :dropdown, click: {redirect_to: "new", open_in: :dialog, params: {page_block: {parent_id: "resource.id"}}}


  associations do
    belongs_to :parent, class_name: "PageBlock", inverse_of: :children, optional: true
    has_many :children, class_name: "PageBlock", inverse_of: :parent
  end
  
  fieldset :page_block, size: 12, styles: @@fieldset_styles do
    field :name
    field :type, type: :select, inclusion: @@types, presence: true, detect_changes: true
    field :position, type: :select, inclusion: @@positions, default: "body", presence: true
    field :parent, type: :select, collection: "/page_blocks"

    fieldset :tabs, styles: @@fieldset_styles, size: 12 do
      fieldset :content, tab: :content , styles: @@fieldset_styles, size: 12 do
        fieldset :text_component, styles: @@fieldset_styles, render_if: "resource.type == 'text'" do
          field :title, size: 9
          field :title_type, type: :select, inclusion: @@text_types, size: 3
          field :subtitle, size: 9
          field :subtitle_type, type: :select, inclusion: @@text_types, size: 3
          field :paragraph, type: :editor, size: 12
        end

        fieldset :button_component, styles: @@fieldset_styles, render_if: "resource.type == 'button'" do
          field :button_text
          field :button_icon
        end

        fieldset :video, styles: @@fieldset_styles, render_if: "resource.type == 'video'" do
          field :video_url
          field :video_width
          field :video_height
        end

        fieldset :photo, styles: @@fieldset_styles, render_if: "resource.type == 'photo'" do
          field :photo, type: :dropzone
        end

        fieldset :photos, styles: @@fieldset_styles, render_if: "resource.type == 'photos'" do
          field :photos, type: :dropzone, multiple: true
        end

        fieldset :chart, styles: @@fieldset_styles, render_if: "resource.type == 'photos'" do
          field :chart_type, type: :select, inclusion: @@chart_types
          field :chart_x, type: :select, tags: true, multiple: true
          field :chart_y, type: :select, tags: true, multiple: true
          #embed data
        end

        fieldset :nav, styles: @@fieldset_styles, render_if: "resource.type == 'nav'" do
          #embed links
        end

        fieldset :form, styles: @@fieldset_styles, render_if: "resource.type == 'form'" do
          #embed inputs
        end
      end

      fieldset :styles, tab: :styles, size: 12, styles: @@fieldset_styles do
        fieldset :margin, header: true, styles: @@fieldset_styles, size: 12 do
          field :margin_left, type: :select, inclusion: @@styles_options,  size: 3
          field :margin_right, type: :select, inclusion: @@styles_options,  size: 3
          field :margin_top, type: :select, inclusion: @@styles_options,  size: 3
          field :margin_bottom, type: :select, inclusion: @@styles_options,  size: 3
        end

        fieldset :padding,header: true,styles: @@fieldset_styles, size: 12 do
          field :padding_left, type: :select, inclusion: @@styles_options,  size: 3
          field :padding_right, type: :select, inclusion: @@styles_options,  size: 3
          field :padding_top, type: :select, inclusion: @@styles_options,  size: 3
          field :padding_bottom, type: :select, inclusion: @@styles_options,  size: 3
        end

        fieldset :border,header: true, styles: @@fieldset_styles, size: 12 do
          field :border_left, type: :select, inclusion: @@styles_options,  size: 3
          field :border_right, type: :select, inclusion: @@styles_options,  size: 3
          field :border_top, type: :select, inclusion: @@styles_options,  size: 3
          field :border_bottom, type: :select, inclusion: @@styles_options,  size: 3
        end

        fieldset :rounded,header: true, styles: @@fieldset_styles, size: 12 do
          field :rounded_top_left, type: :select, inclusion: @@styles_options,  size: 3
          field :rounded_top_right, type: :select, inclusion: @@styles_options,  size: 3
          field :rounded_bottom_left, type: :select, inclusion: @@styles_options,  size: 3
          field :rounded_bottom_right, type: :select, inclusion: @@styles_options,  size: 3
        end

        fieldset :text, header: true, styles: @@fieldset_styles, size: 12 do
          field :text_color, type: :select, inclusion: @@styles_colors, default: "dark"
        end

        fieldset :sizes, header: true, styles: @@fieldset_styles, size: 12 do
          field :body_size, type: :select, inclusion: @@styles_sizes, default: "12", size: 2
          field :left_size, type: :select, inclusion: @@styles_sizes,  size: 2
          field :right_size, type: :select, inclusion: @@styles_sizes,  size: 2
          field :top_size, type: :select, inclusion: @@styles_sizes,  size: 2
          field :bottom_size, type: :select, inclusion: @@styles_sizes,  size: 2
        end

        fieldset :orientation, header: true, styles: @@fieldset_styles, size: 12 do
          field :body_orientation, type: :select, inclusion: @@styles_orientation, default: "horizontal", size: 2
          field :left_orientation, type: :select, inclusion: @@styles_orientation, default: "horizontal", size: 2
          field :right_orientation, type: :select, inclusion: @@styles_orientation, default: "horizontal", size: 2
          field :top_orientation, type: :select, inclusion: @@styles_orientation, default: "horizontal", size: 2
          field :bottom_orientation, type: :select, inclusion: @@styles_orientation, default: "horizontal", size: 2
        end

        fieldset :align, header: true, styles: @@fieldset_styles, size: 12 do
          field :body_align, type: :select, inclusion: @@styles_align, default: "left", size: 2
          field :left_align, type: :select, inclusion: @@styles_align, default: "left", size: 2
          field :right_align, type: :select, inclusion: @@styles_align, default: "left", size: 2
          field :top_align, type: :select, inclusion: @@styles_align, default: "left", size: 2
          field :bottom_align, type: :select, inclusion: @@styles_align, default: "left", size: 2
        end

        fieldset :vertical_align, header: true, styles: @@fieldset_styles, size: 12 do
          field :body_vertical_align, type: :select, inclusion: @@styles_vertical_align, default: "top", size: 2
          field :left_vertical_align, type: :select, inclusion: @@styles_vertical_align, default: "top", size: 2
          field :right_vertical_align, type: :select, inclusion: @@styles_vertical_align, default: "top", size: 2
          field :top_vertical_align, type: :select, inclusion: @@styles_vertical_align, default: "top", size: 2
          field :bottom_vertical_align, type: :select, inclusion: @@styles_vertical_align, default: "top", size: 2
        end

        fieldset :background, header: true, styles: @@fieldset_styles, size: 12 do
          field :background_color, type: :select, inclusion: @@styles_colors, default: "transparent"
          field :background_opacity, type: :select, inclusion: @@styles_opacities, default: "100"
          field :background_image, type: :dropzone
          field :background_type, type: :select, inclusion: %w[cover repeat_x repeat_y repeat_xy]
        end
      end

      fieldset :actions, tab: :actions, size: 12, styles: @@fieldset_styles do
        field :clickable?
        field :click_path
      end
    end
  end

  list :page_blocks, thead: true, type: :tree, expand: {get: "/page_blocks", params: {only_resources: true,filters: {default_scope: "all", parent_id: ":resource.id"}}} do
    add :name
    add :type
    add :position
  end



  list :page_blocks_cards, type: :cards, size: 12, recursive_tree: true, card_size: 12 do


    component :container, name: :block_container, styles: {
      margin: { left: ":resource.margin_left", right: ":resource.margin_right", top: ":resource.margin_top", bottom: ":resource.margin_bottom"},
      padding: { left: ":resource.padding_left", right: ":resource.padding_right", top: ":resource.padding_top", bottom: ":resource.padding_bottom"},
      border: { left: ":resource.border_left", right: ":resource.border_right", top: ":resource.border_top", bottom: ":resource.border_bottom"},
      rounded: { top_left: ":resource.rounded_top_left", top_right: ":resource.rounded_top_right", bottom_left: ":resource.rounded_bottom_left", bottom_right: ":resource.rounded_bottom_right"},
      position_sizes: { body: ":resource.body_size", left: ":resource.left_size", right: ":resource.right_size", bottom: ":resource.bottom_size", top: ":resource.top_size"},
      orientation: { body: ":resource.body_orientation", left: ":resource.left_orientation", right: ":resource.right_orientation", bottom: ":resource.bottom_orientation", top: ":resource.top_orientation"},
      align: { body: ":resource.body_align", left: ":resource.left_align", right: ":resource.right_align", bottom: ":resource.bottom_align", top: ":resource.top_align"},
      vertical_align: { body: ":resource.body_vertical_align", left: ":resource.left_vertical_align", right: ":resource.right_vertical_align", bottom: ":resource.bottom_vertical_align", top: ":resource.top_vertical_align"},
      color: ":resource.text_color",
      background: ":resource.background_color",
      background_opacity: ":resource.opacity",
      background_type: ":resource.background_type"
    }, position: "body", size: ":resource.body_size" do
      component :text, type: :h1, name: :id
    end

  end

  scope :root, ->(){ where(parent_id: nil) }


  def as_json(options={})
    default_json(options).merge({
      children: children.as_json(options)
    })
  end
end