class CommentController < ApplicationController

  ##add_new_comment_start
  def new
	  _id = params[:id]     #수정해야함 @ post = Post.find(_id)
	  @post = Post.find(_id)

    if not session[:logined]
      ##not logined
      redirect_to controller:'user', action:'login_form'
    end
  end


  def create

	  _id= params[:id]
	  _contents=params[:contents]

	  _post = Post.find(_id)

	  comment = Comment.new(post:_post , contents:_contents)
	  comment.save

	  redirect_to controller:'post', action:'list'

  end
  ##add_new_comment_end


  def delete
  end

  def modify
  end

  def update
  end
end
