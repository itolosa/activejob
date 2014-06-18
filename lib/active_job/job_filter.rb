#require 'active_support/rescuable'
require 'active_job/arguments'

module ActiveJob
  module JobFilter
    extend ActiveSupport::Concern

    #included do
    #  include ActiveSupport::Rescuable
    #end

    def default_filtering(job_args, arguments)
      job_args.first == arguments.first
    end

    def filter_job(serialized_args, arguments)
      if defined? filter
        job_args = Array.new(serialized_args)
        job_args[1..-1] = Arguments.deserialize(serialized_args[1..-1])
        filter job_args, arguments
      else
        default_filtering serialized_args, arguments
      end
    end
  end
end
