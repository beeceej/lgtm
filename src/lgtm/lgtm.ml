let is_candidate comment =
  let re_lgtm = Str.regexp_case_fold ".*lgtm.*\\|.*l\\.g\\.t\\.m.*" in
  Str.string_match re_lgtm comment 0
