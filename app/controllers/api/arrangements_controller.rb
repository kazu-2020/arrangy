module Api
  class ArrangementsController < ApplicationController
    skip_before_action :require_login, only: %i[index show]
    before_action :set_arrangement, only: %i[show update destroy]

    def index
      pagy, arrangements = pagy(Arrangement.preload(:user), items: 20)
      options = {
        include: %i[user],
        fields: {
          arrangement: %i[title images created_at likes_count comments_count user],
          user: %i[nickname avatar]
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      render_serializer(arrangements, options)
    end

    def create
      arrangement = current_user.arrangements.build(arrangement_params)
      arrangement.save!
      options = {
        fields: { arrangement: %i[set_id] }
      }
      render_serializer(arrangement, options)
    end

    def show
      # include,fieldsオプションを併用するとrelatiopshipsが{}になる。
      # {}だとフロントで使用しているdevourが期待する値を返してくれない。
      # 参考 => https://github.com/Netflix/fast_jsonapi/issues/304
      options = {
        include: %i[user],
        fields: {
          arrangement: %i[title context images likes_count liked_authuser created_at user],
          user: %i[nickname avatar]
        },
        params: { current_user: current_user }
      }
      render_serializer(@arrangement, options)
    end

    def update
      @arrangement.update!(arrangement_params)
      options = {
        include: %i[user],
        fields: {
          arrangement: %i[title context images user],
          user: %i[nickname avatar]
        }
      }
      render_serializer(@arrangement, options)
    end

    def destroy
      @arrangement.destroy!
      head :no_content
    end

    def mine
      pagy, arrangements = pagy(current_user.arrangements.sorted_by_new, items: 20)
      options = {
        fields: {
          arrangement: %i[title images context created_at likes_count comments_count]
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      render_serializer(arrangements, options)
    end

    def favorites
      pagy, arrangements = pagy(current_user.liking_arrangements.preload(:user), items: 20)
      options = {
        include: %i[user],
        fields: {
          arrangement: %i[title images created_at likes_count comments_count user],
          user: %i[nickname avatar]
        },
        meta: { pagy: pagy_metadata(pagy) }
      }
      render_serializer(arrangements, options)
    end

    private

    def arrangement_params
      params[:arrangement][:images].map! { |image| create_uploadedfile(image) }
      params.require(:arrangement).permit(:title, :context, images: [])
    end

    def set_arrangement
      @arrangement = Arrangement.find(decode_id(params[:id]))
    end

    def render_serializer(arrangement, option)
      json_string = ArrangementSerializer.new(arrangement, option)
      render json: json_string
    end
  end
end
