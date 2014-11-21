TimeTracker::Application.routes.draw do

  resources :tasks
  resources :clients
  resources :priorities do
    put :order, on: :collection
  end
  get 'today' => 'tasks#today'
  get 'yesterday' => 'tasks#yesterday'
  get ':year/:month/:day' => 'tasks#specific_day'
  root :to => 'tasks#index'
end
