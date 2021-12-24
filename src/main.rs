use std::fs;
use std::process::Command;
use std::{thread, time};

use clap::Parser;
use chrono::{Local, Timelike};
use colored::*;

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

    /// Set the levels of verbosity (0 means no output from subprocesses)
    #[clap(short, long, default_value_t = 1)]
    verbose: u8,

}


fn spawn_new(command: String, verbose: u8) {
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

    if verbose == 1 {
        let stdout = String::from_utf8(output.stdout).unwrap();
        let stderr = String::from_utf8(output.stderr).unwrap();
        if !stdout.is_empty() {
            println!("{}", stdout.green())
        }
        if !stderr.is_empty() {
            println!("{}", stderr.red())
        }
    }
}


fn ojo(args: Args) { //file: String, delay: u32, command: String) {
    println!("👁️  Ojo is watching: {}", args.filename);

    let mut metadata = fs::metadata(&args.filename).unwrap();
    assert_eq!(metadata.is_file(), true);

    // NOTE: modification time at start
    let mut time_buffer = metadata.modified().unwrap();

    loop {
        // 1. Sleep
        thread::sleep(time::Duration::from_secs(args.delay as u64));
        // 2. Get new metadata
        metadata = fs::metadata(&args.filename).unwrap();
        let new = metadata.modified().unwrap();
        // 3. Compare to old one
        if new > time_buffer {
            let now = Local::now();
            println!("❗️ Modification detected at {:02}:{:02}:{:02} !", now.hour(), now.minute(), now.second());
            // 3.2 execute command
            spawn_new(args.command.clone(), args.verbose.clone());
            time_buffer = new;
        }
    }
}

fn main() {

    let args = Args::parse();
    ojo(args); 
}

#[cfg(test)]
#[path = "./tests/main_tests.rs"]
mod foo_test;