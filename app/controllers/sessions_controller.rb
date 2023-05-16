class SessionsController < ApplicationController
  skip_before_action :authorize, only: :create

  def create
    # define an attempt to find user
    user = User.find_by(username: params[:username])
    # check if the user exsists and can be auth'ed
    if user&.authenticate(params[:password])
      # add the user id to the session
      session[:user_id] = user.id
      # render the user as JSON
      render json: user
    else
      # render errors as an array
      render json: { errors: ["Invalid username or password"] }, status: :unauthorized
    end
  end

  def destroy
    session.delete :user_id
    head :no_content
  end
end
