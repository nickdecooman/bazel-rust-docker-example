extern crate ferris_says;
extern crate postgres;

use ferris_says::say;
use helper1::Greeter;
use std::io::{stdout, BufWriter};

fn main() {
    let greeter = Greeter::new("Hello");
    let greeting = greeter.greet("world");

    let out = greeting.as_bytes();
    let width = 24;

    let mut writer = BufWriter::new(stdout());
    say(out, width, &mut writer).unwrap();
}
