# Comments

## Fetch project comments

[Doc](https://developers.lokalise.com/reference/list-project-comments)

```elixir
{:ok, comments} = ElixirLokaliseApi.ProjectComments.all(project_id, page: 2, limit: 1)

single_comment = hd comments.items
single_comment.comment
```

## Fetch key comments

[Doc](https://developers.lokalise.com/reference/list-key-comments)

```elixir
{:ok, comments} = ElixirLokaliseApi.KeyComments.all(project_id, key_id, limit: 1, page: 2)
```

## Create key comments

[Doc](https://developers.lokalise.com/reference/create-comments)

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

[Doc](https://developers.lokalise.com/reference/retrieve-a-comment)

```elixir
{:ok, comment} = ElixirLokaliseApi.KeyComments.find(project_id, key_id, comment_id)

comment.comment
comment.comment_id
```

## Delete key comment

[Doc](https://developers.lokalise.com/reference/delete-a-comment)

```elixir
{:ok, resp} = ElixirLokaliseApi.KeyComments.delete(project_id, key_id, comment_id)

assert resp.comment_deleted
```
