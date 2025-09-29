class Api::V1::Admin::Pages::PageBlocksController < Nerdify::ApplicationController
  authenticate User, auth_path: 'users/sign_in'
  template "nerdify/templates/application"

  def default_scope
    :root
  end
end