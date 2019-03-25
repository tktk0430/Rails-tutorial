class AccountActivationsController < ApplicationController
  def edit
    render html: "#{params[:id]},#{params[:email]}"
  end
end
