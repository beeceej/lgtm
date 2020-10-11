open Cohttp_lwt_unix

let load_event ~event_path =
  let ch = open_in event_path in
  let s = really_input_string ch (in_channel_length ch) in
  let () = close_in ch in
  Yojson.Basic.from_string s

let post_comment ~issue_url ~comment ~acronym ~token =
  let headers = Cohttp.Header.init_with "Authorization" ("token " ^ token) in
  let body = Printf.sprintf "> %s\n\n%s" comment acronym in
  let comment = Comment_j.string_of_comment { body } in
  let comment_uri = issue_url ^ "/comments" |> Uri.of_string in
  let _ =
    Lwt_main.run
      (Client.post
         ~body:(Cohttp_lwt.Body.of_string comment)
         ~headers comment_uri)
  in
  ()
