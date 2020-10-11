let is_candidate comment =
  let re_lgtm = Str.regexp_case_fold ".*lgtm.*\\|.*l\\.g\\.t\\.m.*" in
  Str.string_match re_lgtm comment 0

let run () =
  let ctx = Environment.load () in
  let event = Github.load_event ~event_path:ctx.github_event_path in
  let open Yojson.Basic.Util in
  let comment = event |> member "comment" in
  let original_comment_body = comment |> member "body" |> to_string in
  if is_candidate original_comment_body then
    let original_issue_url = comment |> member "issue_url" |> to_string in
    Github.post_comment ~issue_url:original_issue_url
      ~comment:original_comment_body ~acronym:(Words.make_acronym ())
      ~token:ctx.github_token
  else ()
