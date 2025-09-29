class Api::V1::Admin::LeadsController < Nerdify::ApplicationController
  authenticate User, auth_path: 'users/sign_in'
  template "nerdify/templates/application"
end