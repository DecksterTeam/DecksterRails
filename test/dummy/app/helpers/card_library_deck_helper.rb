module CardLibraryDeckHelper
  def render_card_library_deck
    render_deckster_deck :card_library, [
        {card: :custom, load: :async, row: 1, col: 1, sizex: 1, sizey: 1},
        {card: :custom_with_partial, load: :async, row: 1, col: 2, sizex: 1, sizey: 1},
        {card: :icon_counts, load: :async, row: 1, col: 3, sizex: 1, sizey: 1},
    ]
  end
  
  def render_custom_summary_card
    'Custom Card'.html_safe
  end
  
  def render_custom_with_partial_summary_card
    render partial: 'application/custom_with_partial_summary_card'
  end
  
  def render_icon_counts_summary_card
    count_configs = [
         {icon: :youtube, count: 100},
         {title: 'Vimeo', icon: 'vimeo-square', count: 50},
         {icon: :yelp, count: 25},
         
   ]
    render_deckster_icon_counts_card count_configs
  end
end