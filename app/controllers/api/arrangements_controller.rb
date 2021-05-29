module Api
  class ArrangementsController < ApplicationController
    skip_before_action :require_login, only: %i[index show]
    before_action :set_arrangement, only: %i[show update destroy]

    def index
      pagy, arrangements = pagy(
        Arrangement.order(likes_count: :desc).preload(:user,
                                                      :after_arrangement_photo,
                                                      :before_arrangement_photo),
        items: 20
      )
      options = {
        include: %i[user after_arrangement_photo before_arrangement_photo],
        fields: {
          arrangement: %i[title created_at rating likes_count comments_count user after_arrangement_photo
                          before_arrangement_photo],
          after_arrangement_photo: %i[url],
          before_arrangement_photo: %i[url],
          user: %i[nickname avatar_url]
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      render_serializer(arrangements, options)
    end

    def create
      arrangement_form = ArrangementForm.new(arrangement: current_user.arrangements.build,
                                             arrangement_params: arrangement_params,
                                             after_arrangement_photo_params: after_arrangement_photo_params,
                                             before_arrangement_photo_params: before_arrangement_photo_params)
      arrangement_form.save!
      options = {
        fields: { arrangement: %i[set_id] }
      }
      render_serializer(arrangement_form.arrangement, options)
    end

    def show
      # include,fieldsオプションを併用するとrelatiopshipsが{}になる。
      # {}だとフロントで使用しているdevourが期待する値を返してくれない。
      # 参考 => https://github.com/Netflix/fast_jsonapi/issues/304
      options = {
        include: %i[user after_arrangement_photo before_arrangement_photo],
        fields: {
          arrangement: %i[title context rating likes_count liked_authuser created_at user after_arrangement_photo
                          before_arrangement_photo],
          after_arrangement_photo: %i[url],
          before_arrangement_photo: %i[url],
          user: %i[nickname avatar_url]
        },
        params: { current_user: current_user }
      }
      render_serializer(@arrangement, options)
    end

    def update
      arrangement_form = ArrangementForm.new(arrangement: set_arrangement,
                                             arrangement_params: arrangement_params,
                                             after_arrangement_photo_params: after_arrangement_photo_params,
                                             before_arrangement_photo_params: before_arrangement_photo_params)
      arrangement_form.save!
      options = {
        include: %i[user after_arrangement_photo before_arrangement_photo],
        fields: {
          arrangement: %i[title context rating likes_count liked_authuser created_at user after_arrangement_photo
                          before_arrangement_photo],
          after_arrangement_photo: %i[url],
          before_arrangement_photo: %i[url],
          user: %i[nickname avatar_url]
        },
        params: { current_user: current_user }
      }
      render_serializer(arrangement_form.arrangement, options)
    end

    def destroy
      @arrangement.destroy!
      head :no_content
    end

    private

    def arrangement_params
      params.require(:arrangement).permit(:title, :context, :rating)
    end

    def after_arrangement_photo_params
      params.require(:after_arrangement_photo).permit(:url)
    end

    def before_arrangement_photo_params
      params.require(:before_arrangement_photo).permit(:url)
    end

    def set_arrangement
      @arrangement = Arrangement.find(decode_id(params[:id]))
    rescue StandardError => e
      render_404(e)
    end

    def render_serializer(arrangement, options = {})
      json_string = ArrangementSerializer.new(arrangement, options)
      render json: json_string
    end
  end
end
