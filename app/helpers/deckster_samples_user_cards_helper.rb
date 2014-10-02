module DecksterSamplesUserCardsHelper
  def render_new_user_summary_card
    "I am a new user!"
  end

  def render_new_user_detail_card
    "Detailed info about being a new user"
  end

  def render_user_count_summary_card
    # do some database command here to get counts of users
    count_configs = [
        {title: 'Basic Users', icon: :windows, count: 100},
        {title: 'Power Users', icon: :gmail, count: 30},
        {title: 'Admins', icon: :itunes, count: 4},
    ]

    render partial: "deckster/counts_summary_card", locals: {count_configs: count_configs}
  end

  def render_user_count_detail_card
    "Detail Information"
  end
end