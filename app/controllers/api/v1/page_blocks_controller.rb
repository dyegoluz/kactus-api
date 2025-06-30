class Api::V1::PageBlocksController < Nerdify::ApplicationController
  authenticate User, auth_path: 'users/sign_in'
  template "nerdify/templates/applications"

  def default_scope
    :root
  end
end