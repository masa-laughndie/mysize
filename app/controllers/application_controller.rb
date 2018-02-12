class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    #ログイン済みユーザーか確認
    def logged_in_user
      #ログインしていない場合
      unless logged_in?
        #遷移先URLをsessionに一時保存
        store_location
        #dangerフラッシュを表示
        flash[:danger] = "ログインしてください！"
        #login画面へリダイレクト
        #login_「url」なのは/loginの前に余計なurlがある可能性があり完全なurlで誘導するため
        redirect_to login_url
      end
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end
end
