require 'swagger_helper'

RSpec.describe CompetitionsController, type: :request, swagger_doc: 'courses.yaml' do
  let(:competition) { create(:competition) }
  let(:competitions) { create_list(:competition, 10) }
  let(:params) { { competition: attributes_for(:competition) } }
  let(:invalid_params) { { competition: attributes_for(:competition, name: nil) } }

  path '/competitions' do
    get 'list competitions' do
      tags :Competitions
      include_context 'parameters', %i[base_for_index]
      before do
        competitions
        create_list(:competition, 10)
      end

      response 200, 'successful' do
        produces "application/json"
        schema type: :object, required: [ :competitions ],
               properties: { competitions: { type: :array, items: { "$ref": "#/components/schemas/Competition" } } }

        let(:current_permissions) { [ 'competition:read' ] }

        run_test! { expect(json[:competitions].size).to eq(20) }
      end

      include_examples "error_collection", %w[401 403]
    end

    post 'create competition' do
      tags :Competitions
      consumes 'application/json'
      parameter name: :params, in: :body, description: "Модель Competition",
                schema: { type: :object, properties: { competition: { "$ref": "#/components/schemas/Competition" } } }

      let(:competition) { attributes_for(:competition) }
      let(:params) { { competition: competition } }
      let(:current_permissions) { [ 'competition:create' ] }

      response 201, "successful" do
        produces "application/json"
        schema type: :object, required: [ :competition ],
               properties: { competition: { "$ref": "#/components/schemas/Competition" } }
        run_test!
      end

      include_examples "error_collection", %w[401 403 422]
    end
  end

  path '/competitions/{id}' do
    let(:id) { competition.id }

    get 'show competition' do
      tags :Competitions
      produces "application/json"
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'competition:read' ] }

      response 200, 'successful' do
        schema type: :object, properties: { competition: { "$ref": "#/components/schemas/Competition" } }, required: [ :competition ]
        run_test!
      end
      include_examples "error_collection", %w[401 403]
    end

    patch 'update competition' do
      tags :Competitions
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'competition:update' ] }
      consumes "application/json"
      parameter name: :params, in: :body, description: "Модель Competition",
                schema: { type: :object, properties: { competition: { "$ref": "#/components/schemas/Competition" } } }
      response 200, 'successful' do
        produces "application/json"
        schema type: :object, properties: { competition: { "$ref": "#/components/schemas/Competition" } }, required: [ :competition ]
        run_test!
      end
      include_examples "error_collection", %w[400 401 403 422]
    end

    delete('delete competition') do
      tags :Competitions
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'competition:destroy' ] }
      response(204, 'successful') do
        run_test!
      end
      include_examples "error_collection", %w[401 403]
    end
  end
end
