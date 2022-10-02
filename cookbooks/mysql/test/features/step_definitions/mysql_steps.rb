Given 'a new database server with some example data' do

end

When 'I delete a row from a database table' do
  delete_chef 'Alison Holst'
end

When 'I query the database' do
  select_tv_chefs
end

When 'I insert a new row into a database table' do
  insert_chef 'Ainsley Harriott'
end

When 'I update a row in a database table' do
  update_chef_name('Paula Deen', 'Paula Hiers Deen')
end

Then 'the expected data should be returned' do
  tv_chefs.must_equal(['Alison Holst', 'Nigella Lawson', 'Paula Deen'])
end

Then 'the inserted data should be returned for subsequent queries' do
  begin
    select_tv_chefs.must_include 'Ainsley Harriott'
  ensure
    delete_chef 'Ainsley Harriott'
  end
end

Then 'the deleted data should not be returned for subsequent queries' do
  begin
    select_tv_chefs.must_equal(['Nigella Lawson', 'Paula Deen'])
  ensure
    insert_chef 'Alison Holst'
  end
end

Then 'the updated data should be returned for subsequent queries' do
  begin
    select_tv_chefs.must_equal(['Alison Holst', 'Nigella Lawson', 'Paula Hiers Deen'])
  ensure
    update_chef_name('Paula Hiers Deen', 'Paula Deen')
  end
end
