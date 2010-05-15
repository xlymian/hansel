module HanselCore
  module JobQueue
    def jobs
      @jobs
    end

    def push_job job
      job.port = 80 unless job.port
      @jobs.push job
    end

    def pop_job job
      @jobs.pop
    end

    #
    # Load jobs from queue
    #
    def load_job_queue
      (YAML.load_file File.join(config_path, 'jobs.yml')).map do |job|
        self.push_job(OpenStruct.new job)
      end
      self
    end

  end
end
