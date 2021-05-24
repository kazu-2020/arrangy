module Api
  class ArrangementsController < ApplicationController
    skip_before_action :require_login, only: %i[index show]
    before_action :set_arrangement, only: %i[show update destroy]

    def index
      pagy, arrangements = pagy(Arrangement.order(likes_count: :desc).preload(:user, :parameter), items: 20)
      options = {
        include: %i[user parameter photo],
        fields: {
          arrangement: %i[title created_at likes_count comments_count user parameter photo],
          parameter: %i[taste spiciness sweetness satisfaction],
          photo: %i[url],
          user: %i[nickname avatar_url]
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      render_serializer(arrangements, options)
    end

    def create
      arrangement_form = ArrangementForm.new(arrangement: current_user.arrangements.build,
                                             arrangement_params: arrangement_params,
                                             photo_params: photo_params,
                                             parameter_params: parameter_params)
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
        include: %i[user parameter photo],
        fields: {
          arrangement: %i[title context likes_count liked_authuser created_at user parameter photo],
          parameter: %i[taste spiciness sweetness satisfaction],
          photo: %i[url],
          user: %i[nickname avatar_url]
        },
        params: { current_user: current_user }
      }
      render_serializer(@arrangement, options)
    end

    def update
      arrangement_form = ArrangementForm.new(arrangement: set_arrangement,
                                             arrangement_params: arrangement_params,
                                             parameter_params: parameter_params)
      arrangement_form.save!
      options = {
        include: %i[user parameter],
        fields: {
          arrangement: %i[title context likes_count liked_authuser created_at images user parameter],
          parameter: %i[taste spiciness sweetness satisfaction],
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
      params.require(:arrangement).permit(:title, :context)
    end

    def photo_params
      params.require(:photo).permit(:url)
    end

    def parameter_params
      params.require(:parameter).permit(:taste, :spiciness, :sweetness, :satisfaction)
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
