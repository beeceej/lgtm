exception Environment_exn of string

type context = { github_token : string; github_event_path : string }

let get_github_token =
  let v = "GH_TOKEN" in
  Option.to_result ~none:"error parsing environment variable: GH_TOKEN"
    (Sys.getenv_opt v)

let get_github_event_path =
  let v = "GITHUB_EVENT_PATH" in
  Option.to_result ~none:"error parsing environment variable: GITHUB_EVENT_PATH"
    (Sys.getenv_opt v)

let load () : context =
  let token_key, path_key = ("token", "path") in
  let results =
    [ (token_key, get_github_token); (path_key, get_github_event_path) ]
  in
  let maybe_error =
    List.fold_left
      (fun error_set (_, r) ->
        match r with
        | Result.Ok _ -> error_set
        | Result.Error err -> (
            match error_set with
            | Option.Some v -> Option.some (Printf.sprintf "%s\n%s" v err)
            | Option.None -> Option.some err ))
      Option.none results
  in
  let () =
    maybe_error
    |> Option.iter (fun msg ->
           let () = print_string msg in
           raise (Environment_exn msg))
  in

  let github_token, github_event_path =
    ( List.assoc token_key results |> Result.get_ok,
      List.assoc path_key results |> Result.get_ok )
  in
  { github_token; github_event_path }
