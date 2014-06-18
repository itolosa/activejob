require 'active_job/arguments'

module ActiveJob
  module Dequeuing
    extend ActiveSupport::Concern
    module ClassMethods
      # Dequeue an existent job
      #
      #   dequeue("mike")
      #         or
      #   dequeue(user_id)
      #
      # Returns an instance of the job class queued with args available in
      # Job#arguments and the timestamp in Job#enqueue_at.
      def dequeue(*args)
        queue_adapter.dequeue self, *args
      end
    end
  end
end
