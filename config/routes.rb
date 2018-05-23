Rails.application.routes.draw do
  get 'comment/new'

  get 'comment/create'

  get 'comment/delete'

  get 'comment/modify'

  get 'comment/update'

  get 'post/delete'

  get 'new/create'

  get 'new/delete'

  get 'new/modify'

  get 'new/update'

  get 'post/create'

  get 'post/new'

  get 'post/update'

  get 'post/modify'

  get 'post/delete'
	
  get 'post/list'
	
  root 'post#list'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
