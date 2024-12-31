class ApplicationController < ActionController::Base

  before_action :allow_browser, only: [:generate_204]


  private


  def allow_browser

    request.format = :html if request.path == '/generate_204'

  end

end