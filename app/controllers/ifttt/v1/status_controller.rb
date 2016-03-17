class Ifttt::V1::StatusController < ApplicationController
  def show
    if valid_channel_key?
      head :ok
    else
      head :unauthorized
    end
  end
end
