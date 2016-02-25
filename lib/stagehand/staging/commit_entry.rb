module Stagehand
  module Staging
    class CommitEntry < ActiveRecord::Base
      self.table_name = 'stagehand_commit_entries'

      START_OPERATION = 'commit_start'
      END_OPERATION = 'commit_end'
      INSERT_OPERATION = 'insert'
      UPDATE_OPERATION = 'update'
      DELETE_OPERATION = 'delete'

      scope :start_operations,   lambda { where(:operation => START_OPERATION) }
      scope :end_operations,     lambda { where(:operation => END_OPERATION) }
      scope :content_operations, lambda { where.not(:record_id => nil, :table_name => nil) }
      scope :save_operations,    lambda { where(:operation => [INSERT_OPERATION, UPDATE_OPERATION]) }
      scope :delete_operations,  lambda { where(:operation => DELETE_OPERATION) }
      scope :contained,          lambda { where.not(:commit_id => nil) }

      def self.matching(object)
        case object
        when self
          record_id = object.record_id
          table_name = object.table_name
        when ActiveRecord::Base
          record_id = object.id
          table_name = object.class.table_name
        when Array
          record_id, table_name = object
        else
          raise "Invalid input"
        end

        content_operations.where(:record_id => record_id, :table_name => table_name)
      end

      def record
        @record ||= delete_operation? ? build_production_record : record_class.find_by_id(record_id)
      end

      def insert_operation?
        operation == INSERT_OPERATION
      end

      def update_operation?
        operation == UPDATE_OPERATION
      end

      def delete_operation?
        operation == DELETE_OPERATION
      end

      def start_operation?
        operation == START_OPERATION
      end

      def end_operation?
        operation == END_OPERATION
      end

      private

      def build_production_record
        production_record = Stagehand::Production.lookup(record_id, table_name).first
        return unless production_record

        production_record = record_class.new(production_record.attributes)
        production_record.readonly!

        return production_record
      end

      def record_class
        ActiveRecord::Base.descendants.detect {|klass| klass.table_name == table_name && klass != Stagehand::Production::Record }
      end
    end
  end
end
