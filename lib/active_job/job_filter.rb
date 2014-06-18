#require 'active_support/rescuable'
require 'active_job/arguments'

module ActiveJob
  module JobFilter
    extend ActiveSupport::Concern

    #included do
    #  include ActiveSupport::Rescuable
    #end

    def filter_job(enqueued_job, *arguments)
      if defined? filter
        filter enqueued_job, *arguments
      end
    end
  end
end
