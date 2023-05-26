class UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        @user.save
        redirect_to @user
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path, status: :see_other
    end

    private
        def user_params
            params.require(:user).permit(:name)
        end
end
