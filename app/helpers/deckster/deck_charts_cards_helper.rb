module Deckster
  module DeckChartsCardsHelper
    def render_deckster_bubble_chart_card chart_configs
      render partial: "deckster/chart_cards/bubble_chart_card", locals: {chart_configs: chart_configs}
    end

    def render_deckster_cluster_dendrogram_tree_card chart_configs
      render partial: "deckster/chart_cards/cluster_dendrogram_tree", locals: {chart_configs: chart_configs}
    end

    def render_deckster_cluster_dendrogram_radial_card chart_configs
      render partial: "deckster/chart_cards/cluster_dendrogram_radial", locals: {chart_configs: chart_configs}
    end
  end
end
