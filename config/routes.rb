Deckster::Engine.routes.draw do
    match 'deck' => 'deck#deck', as: :deck, via: :all
    match 'card/:id' => 'deck#card', as: :card, via: :all
    match 'table/:id' => 'table#table', as: :table, via: :all
end
