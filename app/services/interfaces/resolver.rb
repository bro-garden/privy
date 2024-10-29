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

    private

    attr_reader :source, :external_id
  end
end
