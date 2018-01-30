Rails.application.routes.draw do
  get 'scales/home'
  post 'scales/pitches'
  post 'scales/name'
  root 'scales#home'
end
