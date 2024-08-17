# frozen_string_literal: true

class SwaggerSchema
  class << self
    def global_schema
      SWAGGER_DOCUMENTS.inject({}) do |h, schema_key|
        h.merge("#{schema_key}.yaml" => load_schema(schema_key))
      end
    end

    def load_schema(schema_key)
      content = File.read(Rails.root.join("spec/requests/#{schema_key}/#{schema_key}.yaml"))
      schema = YAML.safe_load(ERB.new(content).result, symbolize_names: true)
      merge_fragments(schema, :common)
      merge_fragments(schema, schema_key)
      transform_parameters(schema)
      schema
    end

    def merge_fragments(schema, dir)
      Dir[Rails.root.join("spec/schemas/#{dir}/*.yml")].each do |file|
        object_name = File.basename(file, '.yml').to_sym
        content_fragment = File.read file
        schema_fragment = YAML.safe_load(ERB.new(content_fragment).result, symbolize_names: true)
        schema[:components][:schemas].merge!({ object_name => schema_fragment })
      rescue StandardError => e
        puts "error in #{file} schema"
        raise e
      end
    end

    def transform_parameters(schema)
      parameters = schema[:parameters] || schema.dig(:components, :parameters)
      return unless parameters

      parameters.each_key do |parameter|
        parameters[parameter][:in] = parameters[parameter][:in].to_sym
        parameters[parameter][:name] = parameters[parameter][:name].to_sym
      end
    end
  end
end
