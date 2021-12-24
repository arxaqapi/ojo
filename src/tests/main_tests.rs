use super::*;


#[test]

fn test_spawn_new() {
    spawn_new("ls".to_string(), 1);
    spawn_new("ls -lah".to_string(), 1);
}

#[test]
#[should_panic(expected = "Could not execute: kuyagzdky gakzdvk azk")]
fn test_spawn_new_panic() {
    let _result = spawn_new("kuyagzdky gakzdvk azk".to_string(), 1);
}