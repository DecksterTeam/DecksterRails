class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper Deckster::Engine.helpers

  def client_tools_deck
  end

  def card_library_deck
  end

  def sample_contacts_table
  end
end