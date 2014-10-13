module DecksterHelper
  def render_deckster_deck deck_sym, card_configs
    card_contents = card_configs.collect { |card_config| render_deckster_card card_config }
    render partial: "deckster/deck", locals: {deck_sym: deck_sym, card_contents: card_contents}
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

    card_config[:summary_url] ||= deckster_card_path "#{card_config[:card]}_summary"
    card_config[:detail_url] ||= deckster_card_path "#{card_config[:card]}_detail"

    summary_html = render_deckster_summary_card card_config
    detail_html = render_deckster_detail_card card_config

    render partial: "deckster/card", locals: {
        sym: card_config[:card], title: card_config[:title], tooltip: card_config[:tooltip],
        summary_html: summary_html,
        detail_html: detail_html,
        row: card_config[:row], col: card_config[:col], sizex: card_config[:sizex], sizey: card_config[:sizey]
    }
  end

  def render_deckster_summary_card card_config
    content = ([:async, :summary_async].include? card_config[:load]) ?
        'Loading ...' : send("render_#{card_config[:card]}_summary_card".to_sym)

    "<div class='summary' data-summary-url='#{card_config[:summary_url]}'>#{content}</div>".html_safe
  end

  def render_deckster_detail_card card_config
    content = ([:async, :detail_async].include? card_config[:load]) ?
        'Loading ...' : send("render_#{card_config[:card]}_detail_card".to_sym)

    "<div class='detail' style='display:none;' data-detail-url='#{card_config[:detail_url]}'>#{content}</div>".html_safe
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
