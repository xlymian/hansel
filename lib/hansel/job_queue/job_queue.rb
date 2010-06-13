module HanselCore
  module JobQueue
    def jobs
      @jobs
    end

    def push_job job
      @jobs.push job
    end

    def pop_job job
      @jobs.pop
    end

    def load_job_queue
      (YAML.load_file File.join(config_path, 'jobs.yml')).map do |job|
        job.merge!({:port => 80}) unless job[:port]
        self.push_job(OpenStruct.new job)
      end
      self
    end

  end
end
