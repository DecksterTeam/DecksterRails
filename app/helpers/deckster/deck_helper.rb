module Deckster
  module DeckHelper
    def render_deckster_deck deck_config, card_configs, gridster_opts={}
      # deck_config:
      # must have :id
      # :layout => path to layout to render?
      # :controls => array of deck controls to show.
      #              Current options: "refresh"

      card_contents = card_configs.collect { |card_config| render_deckster_card card_config }
      show_deck_controls = deck_config[:controls] && deck_config[:controls].length > 0
      render partial: "deckster/deck/deck", locals: {deck_config: deck_config, card_contents: card_contents, gridster_opts: gridster_opts, show_deck_controls: show_deck_controls}
    end

    def render_deckster_card card_config
      # must have :card :row, :col, :sizex, :sizey
      # :card => the symbol for convention
      # :title
      # :tooltip
      # :load => how it's loaded.
      #    :fully => Summary and Detail are both fully loaded
      #    :async => Summary and Detail are both load asynchronously
      # :summary_url => convention override for the summary card
      # :detail_url => convention override for the detail card

      card_config[:title] ||= card_config[:card].to_s.titleize
      card_config[:load] ||= :fully

      card_config[:summary_url] ||= deckster.card_path "#{card_config[:card]}_summary", layout: false
      card_config[:detail_url] ||= deckster.card_path "#{card_config[:card]}_detail", layout: false

      summary_html = render_deckster_summary_card card_config
      detail_html = render_deckster_detail_card card_config

      render partial: "deckster/deck/card", locals: {
          sym: card_config[:card], title: card_config[:title], tooltip: card_config[:tooltip],
          summary_html: summary_html,
          detail_html: detail_html,
          row: card_config[:row], col: card_config[:col], sizex: card_config[:sizex], sizey: card_config[:sizey]
      }
    end

    def render_deckster_summary_card card_config
      case
        when [:async, :summary_async].include?(card_config[:load])
          content = 'Loading ...'
          loaded = false
        else
          content = send "render_#{card_config[:card]}_summary_card".to_sym
          loaded = true
      end

      "<div class='deckster-summary' data-summary-url='#{card_config[:summary_url]}' data-content-loaded=#{loaded}>#{content}</div>".html_safe
    end

    def render_deckster_detail_card card_config
      case
        when [:async, :detail_async].include?(card_config[:load])
          content = 'Loading ...'
          loaded = false
        else
          content = send "render_#{card_config[:card]}_detail_card".to_sym
          loaded = true
      end

      "<div class='deckster-detail' style='display:none;' data-detail-url='#{card_config[:detail_url]}' data-content-loaded=#{loaded}>#{content}</div>".html_safe
    end
  end
end
