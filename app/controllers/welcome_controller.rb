class WelcomeController < ApplicationController
  def index
    render :index, layout: 'welcome'
  end
end
