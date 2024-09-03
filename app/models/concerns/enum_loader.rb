module EnumLoader
  extend ActiveSupport::Concern

  class_methods do
    def load_enums_from_yaml
      yaml_file_name = name.underscore
      yaml_path = Rails.root.join('config', 'enums', "#{yaml_file_name}.yml")
      return unless File.exist?(yaml_path)

      enums = YAML.load_file(yaml_path)
      upgrade_model(enums)
    end

    private

    def upgrade_model(enums)
      enums.each do |attribute, values|
        unless column_names.include?(attribute.to_s)
          raise "EnumLoader: El atributo `#{attribute}` definido en #{yaml_file_name}.yml no existe en el modelo #{name}."
        end

        options = build_enum_options(values)
        define_enum_methods(attribute, options)
        enum attribute => options.map(&:id)
        const_set(attribute.upcase, options)
      end
    end

    def build_enum_options(values)
      values.map { |item| Struct.new(:id, :name, :label).new(item['id'].to_s, item['name'], item['label']) }
    end

    def define_enum_methods(attribute, options)
      options.each do |option|
        define_method("expires_in_#{option.name}?") { send(attribute) == option.id }
      end
    end
  end
end
