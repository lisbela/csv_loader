class CastMembersController < ApplicationController
    before_action :set_cast_member, only: [:show, :edit, :update]

    def index
        @cast_members = CastMember.all
    end

    def show
    end

    def new
        @cast_member = CastMember.new
    end

    def create
        @cast_member = CastMember.new(cast_member_params)

        if @cast_member.save
            redirect_to @cast_member
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @cast_member.update(cast_member_params)
            redirect_to @cast_member
        else
            render :edit, status: :unprocessable_entity
        end
    end


    private

        def set_cast_member
            @cast_member = CastMember.find(params[:id])
        end

        def cast_member_params
            return params.require(:cast_member).permit(:name, :movie_id)
        end
end
