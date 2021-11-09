class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = Comment.new
    @comments = @post.comments
    @tags = @post.tags
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(title: post_params[:title], content: post_params[:content])
    @post.user_id = current_user.id
    @tag = Tag.new(name: post_params[:tag])
    @tag.save
    respond_to do |format|
      if @post.save
        @post_tag = PostTag.new(post_id:@post.id, tag_id: @tag.id)
        @post_tag.save
        DeletePostJob.set(wait: 60.seconds).perform_later(@post.id)
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.user_id == current_user.id
        respond_to do |format|
        if @post.update(post_params)
            format.html { redirect_to @post, notice: "Post was successfully updated." }
            format.json { render :show, status: :ok, location: @post }
        else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @post.errors, status: :unprocessable_entity }
        end
        end
    else
        respond_to do |format|
            format.html { redirect_to @post, notice: "Unauthorized" }
        end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.user_id == current_user.id
        @post.destroy
        respond_to do |format|
        format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
        end
    else
        respond_to do |format|
        format.html { redirect_to posts_url, notice: "Unauthroized" }
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
        params.require(:post).permit(:title, :content, :tag, :user_id)
    end
    def tag_params
      params.require(:tag).permit(:name)
    end
end
