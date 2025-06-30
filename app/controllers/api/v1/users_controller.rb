class Api::V1::UsersController < Nerdify::SessionsController
  authenticate User, auth_path: "users/sign_in", only: [ :destroy ]
  template "nerdify/templates/sessions"
end
