class Ifttt::V1::UsersController < ApplicationController
  def show
    CreateRegisteredUser.perform_async(user_id: user_id)
    render json: {
      data: {
        name: jwt_payload['data']['username'],
        id: user_id,
        url: "https://ello.co/#{jwt_payload['data']['username']}"
      }
    }.to_json
  end
end
