# Permission templates

[Permission template attributes](https://developers.lokalise.com/reference/permission-template-object)

## Fetch permission templates

[API doc](https://developers.lokalise.com/reference/list-all-permission-templates)

```elixir
{:ok, %PermissionTemplatesCollection{} = templates} = PermissionTemplates.all(team_id)

template = hd(templates)

template.id # => 1
template.role # => "Manager"
template.permissions # => ['branches_main_modify', ...]
template.description # => 'Manage project settings ...'
template.tag # => 'Full access'
template.tagColor # => 'green'
template.tagInfo # => ''
template.doesEnableAllReadOnlyLanguages # => true
```