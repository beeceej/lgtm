module Github = struct
  let token = Sys.getenv "GH_TOKEN"
  let headers = Cohttp.Header.init_with "Authorization" ("token " ^ token)

  let load_event =
    let ch = Sys.getenv "GITHUB_EVENT_PATH" |> open_in  in
    let s = really_input_string ch (in_channel_length ch) in
    let () = close_in ch in
    let () = print_endline s in
    Yojson.Basic.from_string s
end

module Main = struct
  let run () =
    Github.load_event
end

let _ = Main.run ()
