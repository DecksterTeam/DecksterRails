module Deckster
  module DeckCardsHelper
    def render_deckster_icon_counts_card count_configs
      # example config below
      # count_configs = [
      #   {title: 'Basic Users', icon: :windows, count: 100},
      #   {title: 'Power Users', icon: :gmail, count: 30},
      #   {title: 'Admins', icon: :itunes, count: 4},
      # ]
      render partial: "deckster/cards/icon_counts_summary_card", locals: {count_configs: count_configs}
    end
  end
end
