let test_doesnt_contain_lgtm_1 () =
  Alcotest.(check bool) "not even close" false (Lgtm.is_candidate "x")

let test_doesnt_contain_lgtm_2 () =
  Alcotest.(check bool)
    "a statement not containing lgtm" false
    (Lgtm.is_candidate "Going to test this in devsandbox now")

let test_does_contain_lgtm () =
  Alcotest.(check bool)
    "a statement containing lgtm" true (Lgtm.is_candidate "lgtm")

let test_statement_containing_lgtm () =
  Alcotest.(check bool)
    "a statement containing lgtm" true
    (Lgtm.is_candidate "Dang! LGTM")

let test_statement_containing_lgtm_delimited () =
  Alcotest.(check bool) "delimited_by .'s" true (Lgtm.is_candidate "l.g.t.m")

let test_does_contain_LGTM () =
  Alcotest.(check bool)
    "a statement containing LGTM" true (Lgtm.is_candidate "LGTM")

let test_alot_of_text_and_lgtm () =
  Alcotest.(check bool)
    "a statement containing alot of text" true
    (Lgtm.is_candidate
       "asljdflaskjdflkjasdflkjasdkfjalks;jdflk;ajsdflk;jasdfkljasdjfkhasjkdhfkasljdhfjkashdfkjhasdfkjhasdkjfhaksjdhfjkashdfjkhasdfkjhaskldfjhklajsdfkjlahsdfkjlhasdfkjhasdlkfjhlaksdhfkjahsdfkljahsdfkljhsdf \
        LGTM")

let () =
  let open Alcotest in
  run "LGTM"
    [
      ( "should not be considered a candidate",
        [
          test_case "a single letter" `Quick test_doesnt_contain_lgtm_1;
          test_case "a statement not containing lgtm" `Quick
            test_doesnt_contain_lgtm_2;
        ] );
      ( "should be considered a candidate",
        [
          test_case "lowercase lgtm" `Quick test_does_contain_lgtm;
          test_case "uppercase LGTM" `Quick test_does_contain_LGTM;
          test_case "statement containing LGTM" `Quick
            test_statement_containing_lgtm;
          test_case "delimited by .'s" `Quick
            test_statement_containing_lgtm_delimited;
          test_case "a lot of text" `Quick test_alot_of_text_and_lgtm;
        ] );
    ]
