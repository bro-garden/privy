module Listeners
  class JobNotFound < StandardError
    def initialize(job_name)
      super("Job #{job_name} not found")
    end
  end
end
