Rails.application.routes.draw do

  mount Deckster::Engine => "/deckster"
  
  match 'client_tools_deck' => 'application#client_tools_deck', as: :client_tools_deck, via: :all
  match 'card_library_deck' => 'application#card_library_deck', as: :card_library_deck, via: :all
  match 'sample_contacts_table' => 'application#sample_contacts_table', as: :sample_contacts_table, via: :all
end
