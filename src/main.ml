open Cohttp_lwt_unix

let () = Random.self_init ()

module LgtmAcronym = struct
  let make =
    let rand_from_list l = List.nth l (List.length l |> Random.int) in
    let l = rand_from_list Words.l in
    let g = rand_from_list Words.g in
    let t = rand_from_list Words.t in
    let m = rand_from_list Words.m in
    Printf.sprintf "**%s** **%s**  **%s**  **%s**" l g t m
end

module Github = struct
  let token = Sys.getenv "GH_TOKEN"
  let headers = Cohttp.Header.init_with "Authorization" ("token " ^ token)
  let load_event =
    let ch = Sys.getenv "GITHUB_EVENT_PATH" |> open_in  in
    let s = really_input_string ch (in_channel_length ch) in
    let () = close_in ch in
    Yojson.Basic.from_string s
  let post_comment issue_url comment acronym  =
    let body = Printf.sprintf "> %s\n\n%s" comment acronym in
    let comment = Comment_j.string_of_comment {body} in
    let comment_uri = issue_url ^ "/comments" |> Uri.of_string in
    let _ = Lwt_main.run (Client.post
                            ~body:(Cohttp_lwt.Body.of_string comment)
                            ~headers:headers comment_uri) in
    ()
end

module Main = struct
  let run () =
    let event = Github.load_event in
    let open Yojson.Basic.Util in
    let comment = event |> member "comment" in
    let original_comment_body = comment
                                |> member "body"
                                |> to_string in
    let re_lgtm = Str.regexp "[.*lgtm.*|.*l.g.t.m.*]" in
    let matches_lgtm =
      Str.string_match re_lgtm (String.lowercase_ascii original_comment_body ) 0 in
    if matches_lgtm then
      let original_issue_url = comment
                               |> member "issue_url"
                               |> to_string in
      Github.post_comment original_issue_url original_comment_body LgtmAcronym.make
    else
      ()
end

let _ = Main.run ()
