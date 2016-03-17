class Ifttt::V1::StatusController < ApplicationController
  before_action :validate_channel_key

  def show
    head :ok
  end
end
