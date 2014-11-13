class AddModelTokenizerTokenTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table(:<%= table_name %>) do |t|
<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
<%= migration_data -%>
    end

    add_index :<%= table_name %>, :token, unique: true
  end

  def self.down
    # Impelement rollback yourself.
    raise ActiveRecord::IrreversibleMigration
  end
end
