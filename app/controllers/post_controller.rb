class PostController < ApplicationController
  def create
	  _title = params[:title]
	  _author = params[:author]
	  _contents = params[:contents]

	  post = Post.new(title: _title, author: _author , contents: _contents)
	  post.save

	  redirect_to controller:'post', action:'list'

  end

  def new
    if not session[:logined]
      ##not logined
      redirect_to controller:'user', action:'login_form'
    end
  end

  def update
	  _id =params[:id]

	  _title = params[:title]
	  _author = params[:author]
	  _contents = params[:contents]

	  post = Post.find(_id)
	  post.title = _title
	  post.author = _author
	  post.contents = _contents

	  post.save

	  redirect_to controller:'post', action:'list'

  end

  def modify
	  _id = params[:id]
	  @post = Post.find(_id)

  end

  def delete
	  _id = params[:id]
	  post = Post.find(_id)
	  post.destroy

	  redirect_to controller:'post' ,action:'list'
  end

  def list
	  @posts = Post.joins(:comments).all
  end
end
