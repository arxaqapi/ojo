use super::*;

#[test]
#[should_panic(expected = "Argument count does not match!")]
fn test_parse_args() {
    parse_args();
}