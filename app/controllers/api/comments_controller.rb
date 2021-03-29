module Api
  class CommentsController < ApplicationController
    skip_before_action :require_login, only: :index
    before_action :set_comment, only: %i[update destroy]
    def index
      pagy, comments = pagy(Comment.where(arrangement_id: params[:arrangement_id]).order(created_at: :desc).preload(:user), items: 20)
      options = {
        include: %i[user],
        fields: {
          comment: %i[body edited created_at user],
          user: %i[nickname avatar],
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      json_string = CommentSerializer.new(comments, options)
      render json: json_string
    end

    def create
      comment = current_user.comments.build(comment_params)
      comment.save!
      options = {
        include: %i[user],
        fields: {
          comment: %i[body edited created_at user],
          user: %i[nickname avatar]
        }
      }
      json_string = CommentSerializer.new(comment, options)
      render json: json_string
    end

    def update
      @comment.update!(comment_params)
      options = {
        include: %i[user],
        fields: {
          comment: %i[body edited created_at user],
          user: %i[nickname avatar]
        }
      }
      json_string = CommentSerializer.new(@comment, options)
      render json: json_string
    end

    def destroy
      @comment.destroy!
      head :no_content
    end

    private

    def comment_params
      permited_params = params.require(:comment).permit(:body)
      action_name == 'update' ? permited_params : permited_params.merge(arrangement_id: params[:arrangement_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
end
