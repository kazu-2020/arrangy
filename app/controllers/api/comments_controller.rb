module Api
  class CommentsController < ApplicationController
    skip_before_action :require_login, only: :index

    def index
      pagy, comments = pagy(Comment.where(arrangement_id: params[:arrangement_id]).order(created_at: :desc).preload(:user), items: 20)
      options = {
        include: %i[user],
        fields: {
          comment: %i[body created_at user],
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
          comment: %i[body created_at user],
          user: %i[nickname avatar]
        }
      }
      json_string = CommentSerializer.new(comment, options).serializable_hash
      render json: json_string
    end

    def update
    end

    def destroy
    end

    private

    def comment_params
      params.require(:comment).permit(:body).merge(arrangement_id: params[:arrangement_id])
    end
  end
end
