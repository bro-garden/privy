module Discord
  module Resources
    class Application
      attr_reader :id

      def initialize(id:)
        @id = id
      end
    end
  end
end
