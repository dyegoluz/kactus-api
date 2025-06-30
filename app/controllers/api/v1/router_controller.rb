class Api::V1::RouterController < ApplicationController
    def index
        router = params[:router]
        begin
            open_in =  "dialog" if Nerdify.pages["api/v1/"+router.gsub(/^\//, "")].options[:layout] == "modal"
        rescue
        end
        render json: { page: { redirect_to: router, open_in: open_in } }
    end

    def home
        render json: {  redirect_to: "/pages" }
    end

    def admin
        render json: {  redirect_to: "/admin/page_blocks" }
    end
end
