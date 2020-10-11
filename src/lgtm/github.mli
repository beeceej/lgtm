val load_event : event_path:string -> Yojson.Basic.t

val post_comment :
  issue_url:string -> comment:string -> acronym:string -> token:string -> unit
