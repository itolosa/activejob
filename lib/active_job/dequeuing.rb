require 'active_job/arguments'

module ActiveJob
  module Dequeuing
    extend ActiveSupport::Concern
    module ClassMethods
      # Dequeue an existent job
      #
      #   dequeue(user_id)
      #
      def dequeue(*args, &blk)
        queue_adapter.dequeue self, *args, &blk
      end
    end
  end
end
