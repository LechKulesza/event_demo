class AddSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    # Load solid queue schema from queue_schema.rb
    queue_schema_path = Rails.root.join('db', 'queue_schema.rb')

    schema_content = File.read(queue_schema_path)

    instance_eval(schema_content.gsub(/ActiveRecord::Schema\[.*?\]\.define\(.*?\) do\s*|\s*end\s*\z/m, ''))
  end
end
