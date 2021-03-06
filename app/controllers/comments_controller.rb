class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = current_user.comments.build(post_comment_params)
    @kickspost = Kickspost.find_by(id: params[:comment][:kickspost_id])
    @user = @kickspost.user

    if @comment.save
      @comment.create_notice_to_others_and(@user, current_user) if @comment.is_reply?
      @comment.create_comment_notice_for(@user, current_user)
      flash[:success] = "コメントを送信しました"
    else
      flash[:danger] = "コメントを送信できませんでした"
    end

    if params[:display]
      redirect_to kickspost_path(@user, @kickspost, display: params[:display])
    else
      redirect_to kickspost_path(@user, @kickspost)
    end
    
  end

  def destroy
    @comment = comment_deleted
    @kickspost = Kickspost.find_by(id: @comment.kickspost_id)
    @user = @kickspost.user

    @comment.delete_notice_from_others_and(@user, current_user) if @comment.is_reply?
    @comment.delete_comment_notice_from(@user, current_user)

    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to kickspost_path(@user, @kickspost)
  end

  def gooders
    @post = Comment.find_by(id: params[:id])
    @main = @post.kickspost
    @users = @post.gooders.all
    @url = gooders_comment_url(@post)
    render 'shared/gooders'
  end

  private

  def post_comment_params
    params.require(:comment).permit(:kickspost_id, :reply_id, :content)
  end

  def comment_deleted
    comment = Comment.find_by(id: params[:id])
    return comment if has_autority_to_delete(comment)
    redirect_to root_url
  end

  def has_autority_to_delete(comment)
    current_user.admin? || current_user?(comment.user) || current_user?(comment.kickspost.user)
  end
end
