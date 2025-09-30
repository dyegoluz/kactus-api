class User
  include Nerdify::Model
  orm :mongoid

  @@profiles = %w[admin]

  action :index
  action :show, layout: :modal
  action :edit, only: %w[show], on: :member, position: :footer, layout: :modal, click: { redirect_to: "edit", open_in: :dialog }, submit: { put: "..", data: { user: ":resource" }, success: { redirect_to: "..", open_in: :dialog, toast: :success }, error: { toast: :error, update: "components" } }, styles: { background: "secondary", color: "white" }
  action :edit_cancel, only: %w[edit], on: :member, position: :footer, click: { redirect_to: "..", open_in: :dialog }, styles: { background: "transparent", color: "primary" }
  action :update, only: %w[edit], on: :member, position: :footer, click: { submit: "edit_user" }
  action :new, only: %w[index], on: :collection, position: :header, layout: :modal, click: { redirect_to: "new", open_in: :dialog }, submit: { post: "..", data: { user: ":resource" }, success: { close: :dialog, toast: :success }, error: { toast: :error, update: "components" } }
  action :new_cancel, only: %w[new], on: :member, position: :footer, click: { close: :dialog }, styles: { background: "transparent", color: "primary" }
  action :create, only: %w[new], on: :member, position: :footer, click: { submit: "new_user" }
  action :destroy, only: %w[show], on: :member, position: :footer, layout: :modal, click: { delete: ".", confirm: true, success: { close: :dialog, toast: :success }, error: { toast: :error } }, styles: { background: "danger" }

  acts_as_user :database_authenticatable, :invitable, :recoverable

  fieldset :user, styles: {margin: {}, padding: {}, border: {}} do
    field :name, presence: true
    field :cpf, presence: true, uniqueness: true
    field :email, presence: true, uniqueness: true
    field :phone
    field :profile, type: :select, inclusion: @@profiles
    field :password, presence: true, confirmation: true, validate_if: ->() { new_record? || password.present? }, backend_if: "%w(new create edit update).include? params[:action]"
    field :password_confirmation, type: :password, backend_if: "%w(new create edit update).include? params[:action]"
    field :image, type: :dropzone, accept_files: "image/*", size: 4
  end

  filters :users_filter, submit_on_input: true, label: false do
    add :search, type: :search, keywords: %w[name], size: 8
    add :profile, type: :select, inclusion: @@profiles, size: 4
  end

  list :users_table, type: :table, thead: true, paginate: true, paginate_per: 5, click_item: { redirect_to: ":resource.id", open_in: :dialog } do
    add :name
    add :profile
    add :cpf
    add :email
    add :phone
  end

  def phone_number
    self.phone.to_s.gsub(/[\(\)\s\-]/, "")
  end

  def icon
    if self.image.present?
      "<img src='#{image.url}' style='width: 24px; height: 24px;' class='rounded-circle border border-1 border-white'/>".html_safe
    else
      "<div class='avatar-icon bg-white rounded-circle d-flex align-items-center justify-content-center text-primary fw-bold' style='font-size: 10px; width: 24px; height: 24px;'>#{(name || email).to_s.split(' ').map { |text| text.first.upcase }.join[0..1]}</div>".html_safe
    end
  end

  def welcome_photo
    if self.welcome_image.present?
      self.welcome_image.url
    elsif self.image.present?
      self.image.url
    else
      "<div class='avatar-icon bg-white rounded-circle d-flex align-items-center justify-content-center text-primary fw-bold' style='font-size: 10px; width: 24px; height: 24px;'>#{(name || email).to_s.split(' ').map { |text| text.first.upcase }.join[0..1]}</div>".html_safe
    end
  end

  def as_json(options = {})
    default_json(options).merge({
      icon: icon,
      phone_number: phone_number
    })
  end

  def short_name
    self.name.to_s.split(" ").first
  end
end
