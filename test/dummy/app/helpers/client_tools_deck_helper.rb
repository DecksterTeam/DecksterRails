module ClientToolsDeckHelper
  def render_client_tools_deck
    render_deckster_deck :sample_deck_a, [
        {card: :jquery, load: :async, title: 'jQuery', card_classes: 'jquery-card', row: 1, col: 1, sizex: 1, sizey: 1},
        {card: :bootstrap, load: :async, row: 1, col: 2, sizex: 1, sizey: 1},
        {card: :font_awesome, load: :async, title: 'Font Awesome', load: :async, row: 1, col: 3, sizex: 1, sizey: 1},
        {card: :gridster, load: :async, load: :async, row: 1, col: 4, sizex: 1, sizey: 1},
        {card: :exif, load: :async, load: :async, row: 2, col: 1, sizex: 1, sizey: 1},
        {card: :datatables, load: :async, load: :async, row: 2, col: 2, sizex: 1, sizey: 1},
    ]
  end
  
  def render_jquery_summary_card
    'Just an awesome starting point.  Very few web applications are found the do not use jQuery.<p>TEST</p><p>TEST</p><p>TEST</p><p>TEST</p><p>TEST</p><p>TEST</p>'.html_safe
  end
  
  def render_jquery_detail_card
    "Please reference http://jquery.com/ for more info"
  end

  def render_bootstrap_summary_card
    'Bootstrap'
  end
  
  def render_font_awesome_summary_card
    'Font Awesome'
  end
  
  def render_gridster_summary_card
    'Gridster'
  end
  
  def render_exif_summary_card
    'EXIF'.html_safe
  end
  
  def render_datatables_summary_card
    'DataTables'.html_safe
  end
end
