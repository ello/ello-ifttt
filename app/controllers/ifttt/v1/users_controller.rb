class Ifttt::V1::UsersController < ApplicationController
  def show
    render json: {
      data: {
        name: jwt_payload['data']['username'],
        id: jwt_payload['data']['id'],
        url: "https://ello.co/#{jwt_payload['data']['username']}"
      }
    }.to_json
  end
end
