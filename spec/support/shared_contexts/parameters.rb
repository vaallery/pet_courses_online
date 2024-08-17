# frozen_string_literal: true

RSpec.shared_context "parameters" do |parameter_tags|
  parameter_tags = [ parameter_tags ].flatten
  if parameter_tags.include?(:Authorization)
    parameter name: :Authorization,
              description: "Client token",
              in: :header,
              type: :string,
              required: true
  end
  if parameter_tags.include?(:id)
    parameter name: :id,
              description: "Идентификатор",
              in: :path,
              type: :string,
              required: true
  end
  if parameter_tags.include?(:base_for_index)
    parameter name: :search, in: :query, type: :string, required: false,
              description: "Строка для поиска ресурса (часть имени, как пример). Игнорируется если указан filter"
    parameter name: :limit, in: :query, type: :integer, required: false,
              description: "Ограничение кол-ва записей на странице.(100)"
    parameter name: :page, in: :query, type: :integer, required: false,
              description: "Номер страницы"
    parameter name: :sort, in: :query, type: :string, required: false,
              description: "Поле по которому производится сортировка."
    parameter name: :direction, in: :query, type: :string, required: false,
              description: "Направление сортировки [asc | desc]. По умолчанию asc. Игнорируется если указан order"
  end
end
