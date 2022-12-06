import gleam/string
import gleam/list
import gleam/int
import gleam/io

pub type Attack {
  Rock
  Paper
  Scissors
}

pub type Play {
  Play(request: Attack, response: Attack)
}

pub type Result {
  Win
  Draw
  Lose
}

pub fn pt_1(input: String) -> Int {
  input
  |> string.split(on: "\n")
  |> list.map(fn(line) { string.split(line, on: " ") })
  |> list.map(fn(split_line) {
    let [req_str, resp_str] = split_line
    let [req, resp] = [parse_request(req_str), parse_response(resp_str)]
    let play = Play(request: req, response: resp)
    let score = score_play(play)
    score
  })
  |> io.debug()
  |> int.sum()
}

pub fn pt_2(_input: String) -> Int {
  todo
}

pub fn parse_request(request) {
  case request {
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissors
  }
}

pub fn parse_response(response) {
  case response {
    "X" -> Rock
    "Y" -> Paper
    "Z" -> Scissors
  }
}

pub fn score_play(play) {
  let resp_score = score_response(play.response)
  let result_score = play |> calc_result() |> score_result()
  resp_score + result_score
}

pub fn calc_result(play) {
  case play {
    Play(request: Rock, response: Paper) -> Win
    Play(request: Rock, response: Scissors) -> Lose
    Play(request: Paper, response: Rock) -> Lose
    Play(request: Paper, response: Scissors) -> Win
    Play(request: Scissors, response: Rock) -> Win
    Play(request: Scissors, response: Paper) -> Lose
    _ -> Draw
  }
}

pub fn score_response(response) {
  case response {
    Rock -> 1
    Paper -> 2
    Scissors -> 3
  }
}

pub fn score_result(result) {
  case result {
    Win -> 6
    Draw -> 3
    Lose -> 0
  }
}
