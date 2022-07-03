module Api
  module V1
    class KickspostsController < ActionController::API
      def index
        kicksposts = Kickspost.all
        render json: kicksposts
      end
    end
  end
end
