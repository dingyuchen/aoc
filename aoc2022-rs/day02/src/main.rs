use std::io;
use std::io::Read;
use std::collections::HashMap;

#[derive(Eq, PartialEq, Hash, Debug)]
enum Shape {
    Rock,
    Paper,
    Scissors
}

#[derive(Eq, PartialEq, Hash, Debug)]
enum Outcome {
    Win,
    Lose,
    Draw 
}

fn part1(input: &String) {
    let opponent_shapes = HashMap::from([
        ("A", Shape::Rock),
        ("B", Shape::Paper),
        ("C", Shape::Scissors)
    ]);

    let my_shapes = HashMap::from([
        ("X", Shape::Rock),
        ("Y", Shape::Paper),
        ("Z", Shape::Scissors)
    ]);

    let shape_score = HashMap::from([
        (Shape::Rock, 1),
        (Shape::Paper, 2),
        (Shape::Scissors, 3)
    ]);

    let winning_shapes: HashMap<Shape, Shape> = HashMap::from([
        (Shape::Rock, Shape::Paper),
        (Shape::Paper, Shape::Scissors),
        (Shape::Scissors, Shape::Rock)
    ]);


    let scoring = HashMap::from([
        (Outcome::Win, 6),
        (Outcome::Draw, 3),
        (Outcome::Lose, 0)
    ]);

    let score: i64 = input.split("\n")
         .map(|line| line.split(" "))
         .map(|mut choice| {
            (opponent_shapes.get(choice.next().expect("split to have 2 elements"))
                 .expect("invalid lhs"), 
             my_shapes.get(choice.next().expect("split to have 2 elements"))
                 .expect("invalid rhs"))
         })
         .map(|(opponent, me)| {
             if me == winning_shapes.get(opponent).expect("shape not in map") {
                 (me, Outcome::Win)
             } else if me == opponent {
                 (me, Outcome::Draw)
             } else {
                 (me, Outcome::Lose)
             }})
         .map(|(my_choice, outcome)| scoring.get(&outcome).expect("invalid outcome") + shape_score.get(my_choice).expect("invalid shape"))
         .sum();

    println!("{}", score);

}

fn part2(input: &String) {
    let opponent_shapes = HashMap::from([
        ("A", Shape::Rock),
        ("B", Shape::Paper),
        ("C", Shape::Scissors)
    ]);

    let my_outcomes = HashMap::from([
        ("X", Outcome::Lose),
        ("Y", Outcome::Draw),
        ("Z", Outcome::Win)
    ]);

    let shape_score = HashMap::from([
        (Shape::Rock, 1),
        (Shape::Paper, 2),
        (Shape::Scissors, 3)
    ]);

    let winning_shapes: HashMap<Shape, Shape> = HashMap::from([
        (Shape::Rock, Shape::Paper),
        (Shape::Paper, Shape::Scissors),
        (Shape::Scissors, Shape::Rock)
    ]);


    let scoring = HashMap::from([
        (Outcome::Win, 6),
        (Outcome::Draw, 3),
        (Outcome::Lose, 0)
    ]);

    let score: i64 = input.split("\n")
         .map(|line| line.split(" "))
         .map(|mut choice| {
            (opponent_shapes.get(choice.next().expect("split to have 2 elements"))
                 .expect("invalid lhs"), 
             my_outcomes.get(choice.next().expect("split to have 2 elements"))
                 .expect("invalid rhs"))
         })
         .map(|(opponent, outcome)| {
             let win_shape = winning_shapes.get(opponent).expect("shape cannot be beat");
             let lose_shape = winning_shapes.keys().find(|&x| x != win_shape && x != opponent).expect("cannot find losing shape");
             let my_choice = match outcome {
                 Outcome::Win => win_shape,
                 Outcome::Lose => lose_shape,
                 Outcome::Draw => opponent
             };
             (my_choice, outcome)
         })
         .map(|(my_choice, outcome)| scoring.get(&outcome).expect("invalid outcome") + shape_score.get(my_choice).expect("invalid shape"))
         .sum();

    println!("{}", score);
}

fn main() {
    let mut input = String::new();
    io::stdin().lock().read_to_string(&mut input).expect("unable to read stdin");

    part1(&input);
    part2(&input);
}
