use super::*;

#[test]
#[should_panic(expected = "Argument count does not match!")]
fn test_parse_args() {
    parse_args();
}

#[test]

fn test_spawn_new() {
    spawn_new("ls".to_string());
    spawn_new("ls -lah".to_string());
}

#[test]
#[should_panic(expected = "Could not execute: kuyagzdky gakzdvk azk")]
fn test_spawn_new_panic() {
    let _result = spawn_new("kuyagzdky gakzdvk azk".to_string());
}