class CoursesController < ApplicationController
  load_and_authorize_resource

  # GET /courses
  def index
    @courses = CoursesFilter.call(collection: @courses, **filter_params).collection

    courses = paginate(@courses)
    render json: courses, meta: { pagination: pagination_info(courses) }
  end

  # GET /courses/1
  def show
    render json: @course
  end

  # POST /courses
  def create
    render json: Course.create!(course_params), status: :created
  end

  # PATCH/PUT /courses/1
  def update
    @course.update!(course_params)
    render json: @course, status: :ok
  end

  # DELETE /courses/1
  def destroy
    @course.destroy!
    head :no_content
  end

  private

    def course_params
      params.require(:course).permit(:name, :description, :active, :author_id, competition_ids: [])
    end
end
