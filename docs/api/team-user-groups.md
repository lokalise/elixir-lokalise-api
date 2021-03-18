# Team user groups

[Team user group attributes](https://app.lokalise.com/api2docs/curl/#object-team-user-groups)

## Fetch team user groups

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-groups-get)

```elixir
@client.team_user_groups(team_id, params = {})  # Input:
                                                ## team_id (string, required)
                                                ## params (hash)
                                                ### :page and :limit
                                                # Output:
                                                ## Collection of team user groups
```

## Fetch a single group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-group-get)

```elixir
@client.team_user_group(team_id, group_id)  # Input:
                                            ## team_id (string, required)
                                            ## group_id (string, required)
                                            # Output:
                                            ## Group
```

## Create group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-group-post)

```elixir
@client.create_team_user_group(team_id, params) # Input:
                                                ## team_id (string, required)
                                                ## params (hash, required):
                                                ### :name (string, required)
                                                ### :is_reviewer (boolean, required)
                                                ### :is_admin (boolean, required)
                                                ### :admin_rights (array) - required only if is_admin is true
                                                ### :languages (array of hashes) - required if is_admin is false
                                                # Output:
                                                ## Updated group
```

## Update group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-group-put)

```elixir
@client.update_team_user_group(team_id, group_id, params) # Input:
                                                          ## team_id (string, required)
                                                          ## group_id (string, required)
                                                          ## params (hash, required):
                                                          ### :name (string, required)
                                                          ### :is_reviewer (boolean, required)
                                                          ### :is_admin (boolean, required)
                                                          ### :admin_rights (array) - required only if is_admin is true
                                                          ### :languages (array of hashes) - required if is_admin is false
                                                          # Output:
                                                          ## Updated group
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.update(params)
```

## Add projects to group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-add-projects-to-group-put)

```elixir
@client.add_projects_to_group(team_id, group_id, project_ids) # Input:
                                                              ## team_id (string, required)
                                                              ## group_id (string, required)
                                                              ## project_ids (string or array, required) - project ids that you would like to add to this group
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.add_projects projects: [project_id1, project_id2]
```

## Remove projects from group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-remove-projects-from-group-put)

```elixir
@client.remove_projects_from_group(team_id, group_id, project_ids)  # Input:
                                                                    ## team_id (string, required)
                                                                    ## group_id (string, required)
                                                                    ## project_ids (string or array, required) - project ids that you would like to remove from this group
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.remove_projects projects: [project_id1, project_id2]
```

## Add users to group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-add-members-to-group-put)

```elixir
@client.add_users_to_group(team_id, group_id, user_ids) # Input:
                                                        ## team_id (string, required)
                                                        ## group_id (string, required)
                                                        ## user_ids (string or array, required) - user ids that you would like to add to this group
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.add_users users: [user_id1, user_id2]
```

## Remove users from group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-remove-members-from-group-put)

```elixir
@client.remove_users_from_group(team_id, group_id, user_ids)  # Input:
                                                              ## team_id (string, required)
                                                              ## group_id (string, required)
                                                              ## user_ids (string or array, required) - user ids that you would like to add to this group
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.remove_users users: [user_id1, user_id2]
```

## Destroy group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-group-delete)

```elixir
@client.destroy_team_user_group(team_id, group_id)  # Input:
                                                    ## team_id (string, required)
                                                    ## group_id (string, required)
                                                    # Output:
                                                    ## Hash with "team_id" and "group_deleted" set to "true"
```

Alternatively:

```elixir
group = @client.team_user_group('team_id', 'group_id')
group.destroy
```
