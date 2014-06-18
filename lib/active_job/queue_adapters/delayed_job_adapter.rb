require 'delayed_job'

module ActiveJob
  module QueueAdapters
    class DelayedJobAdapter
      class << self
        def enqueue(job, *args)
          priority = 0
          task = JobWrapper.new(job, args)
          Delayed::Job.enqueue(task, priority: priority, queue: job.queue_name)
        end

        def enqueue_at(job, timestamp, *args)
          priority = 0
          enqtime = Time.at(timestamp)
          task = JobWrapper.new(job, args)
          Delayed::Job.enqueue(task, priority: priority, run_at: enqtime, queue: job.queue_name)
        end

        def dequeue(job, *args, &block)
          handler = job.new
          Delayed::Job.all.each do |job_model|
            enqueued_job = job_model.payload_object
            if handler.filter_job(enqueued_job, *args)
              job_model.destroy
            end
          end
        end
      end

      class JobWrapper < Struct.new(:job, :args)
        def perform
          job.new.execute *args
        end
      end
    end
  end
end
