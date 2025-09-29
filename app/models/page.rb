class Page
  include Nerdify::Model
  orm :mongoid


  action :index
  action :show, layout: :default
  action :edit, only: %w(show), on: :member, position: :header, layout: :default, click: {redirect_to: "edit"}, submit: {put: "..", data: {:page => ":resource"}, success: {redirect_to: "..", toast: :success}, error: {toast: :error, update: "components"}}
  action :edit_cancel, only: %w(edit), on: :member, position: :footer, click: {redirect_to: ".."}, styles: {background: "transparent", color: "primary"}
  action :update, only: %w(edit), on: :member,position: :footer, click: {submit: "edit_page"}
  action :new, only: %w(index), on: :collection, position: :header, layout: :default, click: {redirect_to: "new"}, submit: {post: "..", data: {:page =>  ":resource"}, success: {redirect_to: "..", toast: :success}, error: {toast: :error, update: "components"}}
  action :new_cancel, only: %w(new), on: :member,position: :footer, click: {redirect_to: ".."}, styles: {background: "transparent", color: "primary"}
  action :create, only: %w(new), on: :member,position: :footer, click: {submit: "new_page"}
  action :destroy, only: %w(show), on: :member,position: :header, layout: :default, click: {delete: ".", confirm: true, success: {redirect_to: "..", toast: :success}, error: {toast: :error}}, styles: {background: "danger"}
  
  associations do
    has_many :page_blocks
  end
  
  fieldset :page, size: 12 do
    fieldset :tabs, tabs: true, size: 12 do
      fieldset :meta_data, tab: :meta_data, size: 12, styles: {padding: {}, margin: {}, border: {}} do
        field :title
        field :meta_description, type: :textarea
        field :meta_keywords, type: :select, tags: true, multiple: true
        field :domains, type: :select, tags: true, multiple: true
      end
      
      fieldset :scripts, tab: :scripts, size: 12, styles: {padding: {}, margin: {}, border: {}} do
        field :font_import_script, type: :textarea
        field :header_script, type: :textarea
        field :footer_script, type: :textarea
      end

      fieldset :styles, tab: :styles, size: 12, styles: {padding: {}, margin: {}, border: {}} do
        field :h_font_family, size: 6
        field :text_font_family, size: 6

        field :primary_color, size: 4, default: "#57A695"
        field :secondary_color, size: 4, default: "#606062"
        field :info_color, size: 4, default: "#BFBFBF"
        
        field :success_color, size: 4, default: "#62AC63"
        field :danger_color, size: 4, default: "#E27572"
        field :warning_color, size: 4, default: "#FEBE3F"

        field :light_color, size: 4, default: "#F6F6FA"
        field :medium_color, size: 4, default: "#585974"
        field :dark_color, size: 4, default: "#1d2124"
      end
    end
  end

  fieldset :page_blocks, size: 12, header: true, backend_if: "params[:action] == 'show'" do
    embed :page_blocks, path: 'page_blocks', size: 12
  end

  filters :page_filters, submit_on_input: true do
    add :search, type: :search, keywords: %w(title)
  end
  
  list :page_table, type: :table, sortable: :sort, thead: true, click_item: {redirect_to: ":resource.id"} do
    add :title
    add :meta_description
    add :domains
  end
end