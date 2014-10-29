module Deckster
  class TableController < ApplicationController
    def table
      @table_helper = "render_#{params[:id]}_table".to_sym

      respond_to do |format|
        format.js { render layout: false }
        format.html { render layout: false }
      end
    end
  end
end