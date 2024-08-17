# frozen_string_literal: true

RSpec.shared_examples "error_collection" do |codes|
  if codes.include?("400")
    response 400, " Недопустимые параметры" do
      let(:params) { { data: "invalid" } }
      run_test!
    end
  end

  if codes.include?("401")
    response 401, "Учетная запись не авторизована" do
      let(:Authorization) { nil }
      run_test!
    end
  end

  if codes.include?("403")
    response 403, "Нет прав доступа к ресурсу" do
      let(:current_permissions) { [] }
      run_test!
    end
  end

  if codes.include?("404")
    response 404, "Ресурс не найден" do
      let(:id) { 'null' }
      run_test!
    end
  end

  if codes.include?("422")
    response 422, "Недопустимая модель ресурса" do
      let(:params) { invalid_params }
      run_test!
    end
  end
end
