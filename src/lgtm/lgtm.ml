module Environment = struct
  exception Environment_exn of string

  type t = { github_token : string; github_event_path : string }

  let get_github_token =
    let v = "GH_TOKEN" in
    Option.to_result ~none:"error parsing GITHUB_EVENT_PATH" (Sys.getenv_opt v)

  let get_github_event_path =
    let v = "GITHUB_EVENT_PATH" in
    Option.to_result ~none:"error parsing GITHUB_EVENT_PATH" (Sys.getenv_opt v)

  let get_environment_variables () =
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
              | Option.Some v -> Option.some (Printf.sprintf "%s\\n%s" v err)
              | Option.None -> Option.some err ))
        Option.none results
    in
    let () =
      maybe_error |> Option.iter (fun msg -> raise (Environment_exn msg))
    in
    let github_token = List.assoc token_key results |> Result.get_ok in
    let github_event_path = List.assoc path_key results |> Result.get_ok in
    { github_token; github_event_path }
end

let is_candidate comment =
  let re_lgtm = Str.regexp_case_fold ".*lgtm.*\\|.*l\\.g\\.t\\.m.*" in
  Str.string_match re_lgtm comment 0

let () = ()
