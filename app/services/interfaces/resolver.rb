module Interfaces
  class Resolver
    attr_reader :interface

    def initialize(interface_type:, external_id: nil)
      @external_id = external_id
      @interface_type = interface_type
    end

    def create
      @interface = Interface.find_or_create_by!(
        interface_type:,
        external_id:
      )
    end

    private

    attr_reader :external_id, :interface_type
  end
end
