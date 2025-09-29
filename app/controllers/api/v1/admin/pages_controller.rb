class Api::V1::Admin::PagesController < Nerdify::ApplicationController
  authenticate User, auth_path: 'users/sign_in'
  template "nerdify/templates/application"
end