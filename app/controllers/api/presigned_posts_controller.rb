module Api
  class PresignedPostsController < ApplicationController
    skip_before_action :require_login

    def new
      presigned_post = S3_BUCKET.presigned_post(
        key: "uploads/#{SecureRandom.uuid}/${filename}",
        success_action_status: '201',
        acl: 'public-read'
      )
      render json: { meta: { url: presigned_post.url, fields: presigned_post.fields } }
    end
  end
end
