use std::env;
use std::fs;
use std::process::Command;
use std::{thread, time};

fn spawn_new(command: String) {
    assert_eq!(cfg!(target_os = "linux"), true);

    let sub_args: Vec<&str> = command.split(' ').collect();

    let mut process = Command::new(sub_args[0]);

    let output = match sub_args.len() > 1 {
        true => {
            process.args(&sub_args[1..])
        },
        _ => {
            &mut process
        }
    }.output().expect(&format!("Could not execute: {}", command));


    println!("\tstdout: {:?}", String::from_utf8(output.stdout).unwrap());
    println!("\tstderr: {:?}", String::from_utf8(output.stderr).unwrap());
}

fn parse_args() -> (String, u32, String) {
    let args: Vec<String> = env::args().collect();

    if args.len() != 6 || args[2] != "-d" || args[4] != "-x" {
        eprintln!("Usage: ojo <file> -d <delay> -x \"command\"\n");
        panic!("Argument count does not match!");
    }

    let towatch = args[1].clone();
    let d: u32 = args[3].parse::<u32>().unwrap();
    let command: String = args[5].clone();

    return (towatch, d, command);
}

fn ojo(file: String, delay: u32, command: String) {
    println!("👁️  Ojo is watching: {}", file);

    let mut metadata = fs::metadata(&file).unwrap();
    assert_eq!(metadata.is_file(), true);

    // NOTE: modification time at start
    let mut time_buffer = metadata.modified().unwrap();

    loop {
        // 1. Sleep
        thread::sleep(time::Duration::from_secs(delay as u64));
        // 2. Get new metadata
        metadata = fs::metadata(&file).unwrap();
        let new = metadata.modified().unwrap();
        // 3. Compare to old one
        if new > time_buffer {
            println!("Modification detected at <time::now>!");
            // 3.2 execute command
            spawn_new(command.clone());
            time_buffer = new;
        }
    }
}

fn main() {
    
    let tuple = parse_args();

    ojo(tuple.0, tuple.1, tuple.2);
}

#[cfg(test)]
#[path = "./tests/main_tests.rs"]
mod foo_test;