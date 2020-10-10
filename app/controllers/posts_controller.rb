# frozen_string_literal: true

class PostsController < ApplicationController
  ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, :cols]
  REQUIRED_PARAMS = [:per, :cols]

  include Workspaceable
  layout 'backoffice'
  before_action :set_post, only: %i[show edit update destroy]
  before_action { prepend_view_path Rails.root + 'app' + 'views/template' }
  before_action { prepend_view_path Rails.root + 'app' + 'views/table' }

  # GET /posts
  def index
    @posts = Post.__elasticsearch__.search(
      params[:q].presence || '*',
      _source: Columns::PostForm.parsed_columns_for(request),
      sort: "#{params[:sort]}:#{params[:order]}"
    ).page(@pagination_rule.page).per(@pagination_rule.per)

    render 'empty_page' and return if @posts.empty?

    @columns_form = Columns::PostForm.new(displayed_columns: Columns::PostForm.parsed_columns_for(request))
    render 'index', locals: { rows: @posts }
  end

  # GET /posts/1
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title, :status_state, :body)
  end


  def set_settings
    @settings = { singular: :post,
                  plural: :posts,
                  model_class: Post,
                  form_class: Columns::PostForm }
  end

  def set_pagination_rule
    @pagination_rule = PaginationRules.new(request)
  end

  def redirect_with_defaults
    redirect_to url_for(**workspace_params,
                        cols: @settings[:form_class].default_stringified_columns_for(request),
                        per: @pagination_rule.per)
  end
end
