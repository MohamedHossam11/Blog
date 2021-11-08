class CommentsController < ApplicationController
    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.create(comment_params)
        if @comment.save
            redirect_to root_path
        end
    end

    def destroy
        @post = Post.find(params[:post_id])
        @comment = Comment.find(params[:id])
        if @comment.user_id == current_user.id
            @comment.destroy
            redirect_to @post
        else
            respond_to do |format|
                format.html { redirect_to @post, notice: "Unauthorized" }
            end
        end
    end

    private def comment_params
        params.require(:comment).permit(:comment, :user_id)
    end
end
