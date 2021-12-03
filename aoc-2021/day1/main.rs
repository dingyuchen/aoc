fn readlines() -> Vec<i32> {
    use std::io::prelude::*;
    let stdin = std::io::stdin();
    let v = stdin.lock().lines().map(|x| x.unwrap().parse().unwrap()).collect();
    v
}

fn main() {
    let f = readlines();
    let len = f.len();
    let mut count = 0;
    for i in 0..len - 3 {
        let curr = f[i]+f[i + 1]+f[i + 2];
        let next = f[i + 3]+f[i + 1]+f[i + 2];
        if curr < next {
            count += 1;
        }
    }
    println!("{}", count);
}