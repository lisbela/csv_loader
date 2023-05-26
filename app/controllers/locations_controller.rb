class LocationsController < ApplicationController
    brfore_action :set_location, only: [:show, :edit, :update, :destroy]

    def index
        @locations = Location.all
    end

    def show
    end

    def create
        @location = Location.new(location_params)

        if @location.save
            redirect_to @location
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @location.update(location_params)
            redirect_to @location
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @location = Location.find(params[:id])
        @location.destroy

        redirect_to locations_path, status: :see_other
    end

    private

        def set_location
            @location = Location.find(params[:id])
        end

        def location_params
            return params.require(:location).permit(:name)
        end
end
