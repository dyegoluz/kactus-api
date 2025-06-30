

Dado /^(?:que )?(?:eu )?visitei a página "(.*)"$/ do |path|
  visit path
end

Então /^(?:que )?(?:eu )?estou na página "(.*)"$/ do |path|
  expect(page).to have_current_path path
end

Dado /^(?:que )?(?:eu )?cliquei (?:em|no|na) "(.*)"$/ do |element|
  clickable = all('button, input[type="submit"], a, .cursor-pointer', text: element, visible: true).last
  page.execute_script('arguments[0].click();', clickable.native)
end

# Formulários
Dado /^(?:que )?(?:eu )?preenchi "(.*)" com "(.*)"$/ do |field, value|
  fill_in field, with: value
end

Dado /^(?:que )?(?:eu )?selecionei "(.*)" com "(.*)"$/ do |field, value|
  select value, from: field
end

Dado /^(?:que )?(?:eu )?marquei "(.*)"$/ do |field|
  check field
end

Dado /^(?:que )?(?:eu )?desmarquei "(.*)"$/ do |field|
  uncheck field
end

Dado /^(?:que )?(?:eu )?anexei (?:em|no|na) "(.*)" o arquivo "(.*)"$/ do |field, path|
  attach_file field, path
end

Dado /^(?:que )?(?:eu )?vejo "(.*)" em (?:o|a|no|na) "(.*)"$/ do |content, element|
  within element do
    expect(page).to have_content content
  end
end

Dado /^(?:que )?(?:eu )?vejo "(.*)" na p(?:a|á)?gina$/ do |content|
  expect(page).to have_content content
end

Dado /^(?:que )?(?:eu )?vejo "(.*)" (\d+) vezes$/ do |content, n|
  expect(page).to have_content content, count: n.to_i
end

Dado /^(?:que )?(?:eu )?vejo "(.*)" em (?:o|a|no|na) "(.*)" (\d+) vezes$/ do |content, element, n|
  within element do
    expect(page).to have_content content, count: n.to_i
  end
end

Dado /^(?:que )?existe "(.*)"$/ do |element|
  expect(page).to have_selector element
end

Dado /^(?:que )?existe "(.*)" (\d+) vezes$/ do |element, n|
  expect(page).to have_selector element, count: n.to_i
end

Dado /^(?:que )?existe "(.*)" em (?:o|a|no|na) "(.*)"$/ do |element_filho, element_pai|
  within element_pai do
    expect(page).to have_selector element_filho
  end
end

Dado /^(?:que )?(?:eu )?espero "(.*)" segundo(?:s)?$/ do |seconds|
  sleep seconds.to_i
end

Dado /^(?:que )?existe "(.*)" em (?:o|a|no|na) "(.*)" (\d+) vezes$/ do |element_filho, element_pai, n|
  within element_pai do
    expect(page).to have_selector element_filho, count: n.to_i
  end
end

# Cadastro e Login
Dado /^(?:que )?existe (?:um|uma) "(.*)" cadastrad(?:o|a) com:$/ do |model, table|
  attributes = table.rows_hash.symbolize_keys
  obj = model.classify.constantize.create(attributes)
  puts attributes, obj.errors.full_messages if !obj.valid?
  expect(obj.persisted?).to be true
end

Dado /^(?:que )?existe (?:um|uma) "(.*)" cadastrad(?:o|a) na conta com:$/ do |model, table|
  attributes = table.rows_hash.symbolize_keys
  attributes.merge!(account_id: @account.id) if @account.present?
  obj = model.classify.constantize.create(attributes)
  puts attributes, obj.errors.full_messages if !obj.valid?
  expect(obj.persisted?).to be true
  expect(obj.account.present?).to be true
end

Quando /^(?:eu )?clico (?:em|no|na) "(.*)"$/ do |element|
  clickable = all('button, input[type="submit"], a, .cursor-pointer', text: element, visible: true).last
  page.execute_script('arguments[0].click();', clickable.native)
end

# Formulários
Quando /^(?:eu )?preencho "(.*)" com "(.*)"$/ do |field, value|
  fill_in field, with: value
end

Quando /^(?:eu )?seleciono "(.*)" com "(.*)"$/ do |field, value|
  select value, from: field
end

Quando /^(?:eu )?marco "(.*)"$/ do |field|
  check field
end

Quando /^(?:eu )?desmarco "(.*)"$/ do |field|
  uncheck field
end

Quando /^(?:eu )?anexo (?:em|no|na) "(.*)" o arquivo "(.*)"$/ do |field, path|
  attach_file field, path
end

Quando /^(?:eu )?vejo "(.*)" (\d+) vezes$/ do |content, n|
  expect(page).to have_content content, count: n.to_i
end

Quando /^(?:eu )?vejo "(.*)" (?:em|o|a|no|na) "(.*)" (\d+) vezes$/ do |content, element, n|
  within element do
    expect(page).to have_content content, count: n.to_i
  end
end

Quando /^existe "(.*)"$/ do |element|
  expect(page).to have_selector element
end

Quando /^existe "(.*)" (\d+) vezes$/ do |element, n|
  expect(page).to have_selector element, count: n.to_i
end

Quando /^existe "(.*)" em (?:o|a|no|na) "(.*)"$/ do |element_filho, element_pai|
  within element_pai do
    expect(page).to have_selector element_filho
  end
end

Quando /^existe "(.*)" em (?:o|a|no|na) "(.*)" (\d+) vezes$/ do |element_filho, element_pai, n|
  within element_pai do
    expect(page).to have_selector element_filho, count: n.to_i
  end
end

# Cadastro e Login
Quando /^existe (?:um|uma) "(.*)" cadastrad(?:o|a) com:$/ do |model, table|
  attributes = table.rows_hash.symbolize_keys
  obj = model.classify.constantize.create(attributes)
  puts attributes, obj.errors.full_messages if !obj.valid?
  expect(obj.persisted?).to be true
end

Quando /^existe (?:um|uma) "(.*)" cadastrad(?:o|a) na conta com:$/ do |model, table|
  attributes = table.rows_hash.symbolize_keys
  attributes.merge!(account_id: @account.id) if @account.present?
  obj = model.classify.constantize.create(attributes)
  puts attributes, obj.errors.full_messages if !obj.valid?
  expect(obj.persisted?).to be true
  expect(obj.account.present?).to be true
end


Então /^(?:eu )?(?:eu )?visitei a página "(.*)"$/ do |path|
  visit path
end


Então /^(?:eu )?marquei "(.*)"$/ do |field|
  check field
end

Então /^(?:eu )?desmarquei "(.*)"$/ do |field|
  uncheck field
end

Então /^(?:eu )?anexei (?:em|no|na) "(.*)" o arquivo "(.*)"$/ do |field, path|
  attach_file field, path
end


Então /^(?:eu )?existe "(.*)"$/ do |element|
  expect(page).to have_selector element
end

Então /^(?:eu )?existe "(.*)" (\d+) vezes$/ do |element, n|
  expect(page).to have_selector element, count: n.to_i
end

Então /^(?:eu )?existe "(.*)" em (?:o|a|no|na) "(.*)"$/ do |element_filho, element_pai|
  within element_pai do
    expect(page).to have_selector element_filho
  end
end

Então /^(?:eu )?existe "(.*)" em (?:o|a|no|na) "(.*)" (\d+) vezes$/ do |element_filho, element_pai, n|
  within element_pai do
    expect(page).to have_selector element_filho, count: n.to_i
  end
end
