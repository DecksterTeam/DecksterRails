module Deckster
  class DeckController < ApplicationController
    def deck
    end

    def card
      @card_helper = "render_#{params[:id]}_card".to_sym

      params[:'layout'] = false if params[:'layout'] == false.to_s

      respond_to do |format|
        format.html { render layout: params[:'layout'] }
      end
    end
  end
end