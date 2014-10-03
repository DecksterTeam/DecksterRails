module DecksterHelper
  def render_deckster_deck deck_sym, card_configs
    card_contents = card_configs.collect { |card_config|
      render_fully_loaded_card card_config[:card], card_config[:title] || card_config[:card].to_s.titleize,
                  card_config[:tooltip],
                  card_config[:row], card_config[:col], card_config[:sizex], card_config[:sizey]
    }

    render partial: "deckster/deck", locals: {deck_sym: deck_sym, card_contents: card_contents}
  end

  def render_fully_loaded_card card_sym, card_title, tooltip, row, col, sizex, sizey
    summary_html = send "render_#{card_sym}_summary_card".to_sym
    detail_html = send "render_#{card_sym}_detail_card".to_sym

    render partial: "deckster/card", locals: {
        sym: card_sym, title: card_title, tooltip: tooltip,
        summary_html: "<div class='summary'>#{summary_html}</div>".html_safe,
        detail_html: "<div class='detail' style='display:none;'>#{detail_html}</div>".html_safe,
        row: row, col: col, sizex: sizex, sizey: sizey
    }
  end
  
  def render_deckster_count_card count_configs
    # example config below
    # count_configs = [
    #   {title: 'Basic Users', icon: :windows, count: 100},
    #   {title: 'Power Users', icon: :gmail, count: 30},
    #   {title: 'Admins', icon: :itunes, count: 4},
    # ]
    render partial: "deckster/counts_summary_card", locals: {count_configs: count_configs}
  end
end
