require 'swagger_helper'

RSpec.describe CoursesController, type: :request, swagger_doc: 'courses.yaml' do
  let(:course) { create(:course) }
  let(:courses) { create_list(:course, 10) }
  let(:params) { { course: attributes_for(:course, competition_ids: create_list(:competition, 2).pluck(:id)) } }
  let(:invalid_params) { { course: attributes_for(:course, name: nil) } }

  path '/courses' do
    get 'list courses' do
      tags :Courses
      include_context 'parameters', %i[base_for_index]
      before do
        courses
        create_list(:course, 10)
      end

      response 200, 'successful' do
        produces "application/json"
        schema type: :object, required: [ :courses ],
               properties: { courses: { type: :array, items: { "$ref": "#/components/schemas/Course" } } }

        let(:current_permissions) { [ 'course:read' ] }

        run_test! { expect(json[:courses].size).to eq(20) }
      end

      include_examples "error_collection", %w[401 403]
    end

    post 'create course' do
      tags :Courses
      consumes 'application/json'
      parameter name: :params, in: :body, description: "Модель Course",
                schema: { type: :object, properties: { course: { "$ref": "#/components/schemas/Course" } } }

      let(:author) { create(:author) }
      let(:course) { attributes_for(:course, author_id: author.id) }
      let(:params) { { course: course } }
      let(:current_permissions) { [ 'course:create' ] }

      response 201, "successful" do
        produces "application/json"
        schema type: :object, required: [ :course ],
               properties: { course: { "$ref": "#/components/schemas/Course" } }
        run_test!
      end

      include_examples "error_collection", %w[401 403 422]
    end
  end

  path '/courses/{id}' do
    let(:id) { course.id }

    get 'show course' do
      tags :Courses
      produces "application/json"
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'course:read' ] }

      response 200, 'successful' do
        schema type: :object, properties: { course: { "$ref": "#/components/schemas/Course" } }, required: [ :course ]
        run_test!
      end
      include_examples "error_collection", %w[401 403]
    end

    patch 'update course' do
      tags :Courses
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'course:update' ] }
      consumes "application/json"
      parameter name: :params, in: :body, description: "Модель Course",
                schema: { type: :object, properties: { course: { "$ref": "#/components/schemas/Course" } } }
      response 200, 'successful' do
        produces "application/json"
        schema type: :object, properties: { course: { "$ref": "#/components/schemas/Course" } }, required: [ :course ]

        run_test! do
          expect(json[:course][:competition_ids].size).to eq(2)
        end
      end
      include_examples "error_collection", %w[400 401 403 422]
    end

    delete('delete course') do
      tags :Courses
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'course:destroy' ] }
      response(204, 'successful') do
        run_test!
      end
      include_examples "error_collection", %w[401 403]
    end
  end
end
