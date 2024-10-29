module Interfaces
  class Resolver
    attr_reader :interface

    def initialize(source:, external_id: nil)
      @source = source
      @external_id = external_id
    end

    def call
      @interface = Interface.find_or_create_by!(
        external_id:,
        source:
      )
    end

    def find_interface
      @interface = Interface.api if source == :api
      @interface = Interface.web if source == :web
      @interface = Interface.find_by(source:, external_id:) if @interface.blank?

      raise Messages::InterfaceNotFound, external_id unless @interface
    end

    private

    attr_reader :source, :external_id
  end
end
