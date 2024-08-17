class AuthorsController < ApplicationController
  load_and_authorize_resource

  # GET /authors
  def index
    @authors = AuthorsFilter.call(collection: @authors, **filter_params).collection

    authors = paginate(@authors)
    render json: authors, meta: { pagination: pagination_info(authors) }
  end

  # GET /authors/1
  def show
    render json: @author
  end

  # POST /authors
  def create
    render json: Author.create!(author_params), status: :created
  end

  # PATCH/PUT /authors/1
  def update
    @author.update!(author_params)
    render json: @author, status: :ok
  end

  # DELETE /authors/1
  def destroy
    @author.destroy!
    head :no_content
  end

  private

    def author_params
      params.require(:author).permit(:name, :description, :active)
    end
end
