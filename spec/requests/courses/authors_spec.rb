require 'swagger_helper'

RSpec.describe AuthorsController, type: :request, swagger_doc: 'courses.yaml' do
  let(:author) { create(:author) }
  let(:authors) { create_list(:author, 10) }
  let(:params) { { author: attributes_for(:author) } }
  let(:invalid_params) { { author: attributes_for(:author, name: nil) } }

  path '/authors' do
    get 'list authors' do
      tags :Authors
      include_context 'parameters', %i[base_for_index]
      before do
        authors
        create_list(:author, 10)
      end

      response 200, 'successful' do
        produces "application/json"
        schema type: :object, required: [ :authors ],
               properties: { authors: { type: :array, items: { "$ref": "#/components/schemas/Author" } } }

        let(:current_permissions) { [ 'author:read' ] }

        run_test! { expect(json[:authors].size).to eq(20) }
      end

      include_examples "error_collection", %w[401 403]
    end

    post 'create author' do
      tags :Authors
      consumes 'application/json'
      parameter name: :params, in: :body, description: "Модель Author",
                schema: { type: :object, properties: { author: { "$ref": "#/components/schemas/Author" } } }

      let(:author) { attributes_for(:author) }
      let(:params) { { author: author } }
      let(:current_permissions) { [ 'author:create' ] }

      response 201, "successful" do
        produces "application/json"
        schema type: :object, required: [ :author ],
               properties: { author: { "$ref": "#/components/schemas/Author" } }
        run_test!
      end

      include_examples "error_collection", %w[401 403 422]
    end
  end

  path '/authors/{id}' do
    let(:id) { author.id }

    get 'show author' do
      tags :Authors
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'author:read' ] }

      produces "application/json"
      response 200, 'successful' do
        schema type: :object, properties: { author: { "$ref": "#/components/schemas/Author" } }, required: [ :author ]
        run_test!
      end

      include_examples "error_collection", %w[401 403]
    end

    patch 'update author' do
      tags :Authors
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'author:update' ] }
      consumes "application/json"
      parameter name: :params, in: :body, description: "Модель Author",
                schema: { type: :object, properties: { author: { "$ref": "#/components/schemas/Author" } } }
      response 200, 'successful' do
        produces "application/json"
        schema type: :object, properties: { author: { "$ref": "#/components/schemas/Author" } }, required: [ :author ]
        run_test!
      end
      include_examples "error_collection", %w[400 401 403 422]
    end

    delete('delete author') do
      tags :Authors
      include_context "parameters", %i[id]
      let(:current_permissions) { [ 'author:destroy' ] }
      response(204, 'successful') do
        run_test!
      end
      include_examples "error_collection", %w[401 403]
    end
  end
end
