require 'delayed_job'

module ActiveJob
  module QueueAdapters
    class DelayedJobAdapter

      def default_chkid task, *args
        ActiveJob::Arguments.deserialize(task.args).first == args.first
      end

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
          if block_given?
            chkid = Proc.new do |job, args| yield(job, *args) end
          else
            chkid = Proc.new do |job, args| default_chkid(job, *args) end
          end

          Delayed::Job.all.each do |enqjob|
            task = enqjob.payload_object
            if chkid(task, args)
              enqjob.destroy
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
