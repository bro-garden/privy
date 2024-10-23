module Discord
  module Resources
    class Guild
      attr_reader :id

      def initialize(id:)
        @id = id
      end
    end
  end
end
