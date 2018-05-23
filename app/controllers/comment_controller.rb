class CommentController < ApplicationController
  def new
	  _id = params[:id]     #수정해야함 @ post = Post.find(_id)
	  @post = Post.find(_id)
  end

  def create
	  
	  _id= params[:id]
	  _contents=params[:contents]
	  
	  _post = Post.find(_id) 
	  
	  comment = Comment.new(post:_post , contents:_contents)
	  comment.save 
	  
	  redirect_to controller:'post', action:'list'
	  
  end

  def delete 
  end

  def modify
  end

  def update
  end
end
