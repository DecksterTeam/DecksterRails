module Deckster
  module DeckHelper
    def render_deckster_deck deck_config, card_configs, gridster_opts={}
      # deck_config:
      # must have :id
      # :layout => path to layout to render?
      # :controls => array of deck controls to show.
      #              Current options: "refresh", "search"

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
      # :card_classes => custom css class(es) to add to the card wrapper
      # :sharedView = boolean value - renders one view for both expanded and summary view.
      # :defaultLoad => boolean value - load card on default dashboard
      # :visibility => string value - card css visibility
      # :visualizations => Array of Objects (visualizations)
      #       Visualization Object:
      #         - id: id of chart (must be unique)
      #         - type: string, options: 'radial'
      #         - title: string
      #         - data_source: string
      #         - description: string
      #         - show_legend: boolean, defaults to true for visualizations with 3+ arcs
      #         - theme: string, determines color of arcs. options: 'blue' (default), 'green'
      #         - style: string, options: 'concentric' (default), 'cumulative'
      #         - sort: boolean, defaults to true. Sorts arcs so largest is on the outside of the circle.
      #         - fill: boolean, adjust raw data values to percentages
      #       Example:
      #         people_visualizations = [
      #           {type: 'radial', title: 'Friends', data_source: 'collect_friends_data', description: 'friend desc'},
      #           {type: 'radial', title: 'Enemies', data_source: 'collect_enemies_data', description: 'enemy desc'}
      #         ]
      # :layout_visualizations => boolean value - render visualizations in custom layout (provides vis data in array to partial)

      card_config[:title] ||= card_config[:card].to_s.titleize
      card_config[:load] ||= :fully

      unless card_config[:visualizations].nil?
        vizzes = render_visualization_cards card_config
      end

      shared = !card_config[:sharedView].nil? and card_config[:sharedView]
      if shared
        card_config[:shared_url] ||= deckster.card_path "#{card_config[:card]}_shared", layout: false
        shared_html = render_deckster_shared_card card_config
      else
        card_config[:summary_url] ||= deckster.card_path "#{card_config[:card]}_summary", layout: false
        card_config[:detail_url] ||= deckster.card_path "#{card_config[:card]}_detail", layout: false
        summary_html = render_deckster_summary_card card_config
        detail_html = render_deckster_detail_card card_config
      end

      locals = {
          sym: card_config[:card], title: card_config[:title], tooltip: card_config[:tooltip],
          summary_html: summary_html,
          detail_html: detail_html,
          shared_html: shared_html,
          is_shared_view: shared,
          row: card_config[:row], col: card_config[:col], sizex: card_config[:sizex],
          sizey: card_config[:sizey], card_classes: card_config[:card_classes],
          display: card_config[:display],
          expandable: (card_config[:expandable].nil? or card_config[:expandable])
      }
      locals[:visualizations] = (card_config[:layout_visualizations].nil? or !card_config[:layout_visualizations]) ? vizzes : []

      render partial: "deckster/deck/card", locals: locals
    end

    def render_deckster_shared_card card_config
      case
        when (!card_config[:layout_visualizations].nil? and card_config[:layout_visualizations])
          content = send "render_#{card_config[:card]}_shared_card".to_sym, { visualizations: render_visualization_cards(card_config) }
          loaded = true
        when [:async, :summary_async].include?(card_config[:load])
          content = 'Loading ...'
          loaded = false
        else
          content = send "render_#{card_config[:card]}_shared_card".to_sym
          loaded = true
      end

      "<div class='deckster-shared' data-shared-url='#{card_config[:shared_url]}' data-content-loaded=#{loaded}>#{content}</div>".html_safe
    end

    def render_deckster_summary_card card_config
      case
        when (!card_config[:layout_visualizations].nil? and card_config[:layout_visualizations])
          content = send "render_#{card_config[:card]}_summary_card".to_sym, { visualizations: render_visualization_cards(card_config) }
          loaded = true
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
        when (!card_config[:layout_visualizations].nil? and card_config[:layout_visualizations])
          content = send "render_#{card_config[:card]}_detail_card".to_sym, { visualizations: render_visualization_cards(card_config) }
          loaded = true
        when [:async, :detail_async].include?(card_config[:load])
          content = 'Loading ...'
          loaded = false
        else
          content = send "render_#{card_config[:card]}_detail_card".to_sym
          loaded = true
      end

      "<div class='deckster-detail' style='display:none;' data-detail-url='#{card_config[:detail_url]}' data-content-loaded=#{loaded}>#{content}</div>".html_safe
    end

    def render_visualization_cards card_config
      data = card_config[:visualizations]
      data.map {|viz|
        case viz[:type]
          when 'radial'
            viz[:content] = [ (send viz[:data_source]) ].flatten
            viz[:content].sort_by! do |item| -item[:percent] end if viz[:sort].nil? or viz[:sort]
            if !viz[:fill].nil? and viz[:fill]
              percentages = viz[:content].map{|item| item[:percent]}
              total = percentages.sum
              viz[:content].map!{|item| item[:percent] = item[:percent] * 1.0 / total * 100; item }
            end
            smallerDirection = [card_config[:sizex], card_config[:sizey]].min
            diameter = smallerDirection == 1 ? 120 : 150
            render partial: "deckster/chart_cards/radial_card", locals: { viz: viz, diameter: diameter }
          else
            'DID NOT WORK'
        end
      }
    end
  end
end
