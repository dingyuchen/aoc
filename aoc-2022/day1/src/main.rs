use std::io;
use std::io::Read;
use std::cmp::Reverse;

fn readlines() -> String {
    let mut buffer = String::new();
    io::stdin().lock().read_to_string(&mut buffer)
        .expect("unable to read stdin");
    return buffer
}

fn main() {
    let mut input: Vec<u32> = readlines().split("\n\n")
        .filter_map(|group| group.split("\n")
                    .filter_map(|food| food.parse::<u32>().ok())
                    .reduce(|acc, x| acc + x))
        .collect();
    input.sort_by_key(|cal| Reverse(*cal));
    let total: u32 = input[0..3].iter().sum();
    println!("{:?}", total);
}
