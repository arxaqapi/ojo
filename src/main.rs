use std::env;
use std::fs;
use std::process::Command;
use std::{thread, time};

use clap::Parser;

/// ojo is a command line tool that watches periodically for modification in the specified file
/// and executes a certain command
#[derive(Parser, Debug)]
#[clap(about, version, author = "arxaqapi. <github.com/arxaqapi>")]
struct Args {
    /// File input
    #[clap(index = 1, required = true)]
    filename: String,

    /// Delay between each patrol in seconds
    #[clap(short, long, default_value_t = 2)]
    delay: u32,

    /// Command to execute
    #[clap(short = 'x', long = "execute")]
    command: String,
}


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
            println!("\u{1F6D1} Modification detected at <time::now>!");
            // 3.2 execute command
            spawn_new(command.clone());
            time_buffer = new;
        }
    }
}

fn main() {
    let args = Args::parse();

    ojo(args.filename, args.delay, args.command);
}

#[cfg(test)]
#[path = "./tests/main_tests.rs"]
mod foo_test;