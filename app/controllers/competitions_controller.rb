class CompetitionsController < ApplicationController
  load_and_authorize_resource

  # GET /competitions
  def index
    @competitions = CompetitionsFilter.call(collection: @competitions, **filter_params).collection

    competitions = paginate(@competitions)
    render json: competitions, meta: { pagination: pagination_info(competitions) }
  end

  # GET /competitions/1
  def show
    render json: @competition
  end

  # POST /competitions
  def create
    render json: Competition.create!(competition_params), status: :created
  end

  # PATCH/PUT /competitions/1
  def update
    @competition.update!(competition_params)
    render json: @competition, status: :ok
  end

  # DELETE /competitions/1
  def destroy
    @competition.destroy!
    head :no_content
  end

  private

    def competition_params
      params.require(:competition).permit(:name, :description, :active)
    end
end
