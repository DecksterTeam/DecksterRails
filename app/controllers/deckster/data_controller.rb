module Deckster
  class DataController < ApplicationController
    def data
      @data_helper = "render_#{params[:id]}_data".to_sym

      respond_to do |format|
        format.js { render layout: false }
        format.json { render layout: false }
        format.html { render layout: false }
      end
    end
  end
end