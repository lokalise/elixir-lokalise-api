# Comments

[Comments attributes](https://app.lokalise.com/api2docs/curl/#resource-comments)

## Fetch project comments

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-project-comments-get)

```elixir
{:ok, comments} = ElixirLokaliseApi.ProjectComments.all(project_id, page: 2, limit: 1)

single_comment = hd comments.items
single_comment.comment
```

## Fetch key comments

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-key-comments-get)

```elixir
{:ok, comments} = ElixirLokaliseApi.KeyComments.all(project_id, key_id, limit: 1, page: 2)
```

## Create key comments

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-comments-post)

```elixir
data = %{
  comments: [
    %{comment: "Elixir comment"}
  ]
}

{:ok, comments} = ElixirLokaliseApi.KeyComments.create(project_id, key_id, data)
comment = hd comments.items
comment.comment
```

## Fetch key comment

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-comment-get)

```elixir
{:ok, comment} = ElixirLokaliseApi.KeyComments.find(project_id, key_id, comment_id)

comment.comment
comment.comment_id
```

## Delete key comment

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-comment-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.KeyComments.delete(project_id, key_id, comment_id)

assert resp.comment_deleted
```
