class DecksterController < ApplicationController
  def card
    @card_helper = "render_#{params[:id]}_card".to_sym

    respond_to do |format|
      format.html { render layout: false }
    end
  end
end