module Deckster
  module DeckChartsCardsHelper
    def render_deckster_bubble_chart_card chart_configs
      render partial: "deckster/chart_cards/bubble_chart_card", locals: {chart_configs: chart_configs}
    end
  end
end
