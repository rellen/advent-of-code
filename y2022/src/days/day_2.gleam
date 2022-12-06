import gleam/string
import gleam/list
import gleam/int

pub type Attack {
  Rock
  Paper
  Scissors
}

pub type Play1 {
  Play1(request: Attack, response: Attack)
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
    score_play(Play1(
      request: parse_request(req_str),
      response: parse_response(resp_str),
    ))
  })
  |> int.sum()
}

pub fn pt_2(input: String) -> Int {
  input
  |> string.split(on: "\n")
  |> list.map(fn(line) { string.split(line, on: " ") })
  |> list.map(fn(split_line) {
    let [req_str, res_str] = split_line
    let req = parse_request(req_str)
    let res = parse_result(res_str)
    score_response(calc_response(req, res)) + score_result(res)
  })
  |> int.sum()
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

pub fn parse_result(result: String) -> Result {
  case result {
    "X" -> Lose
    "Y" -> Draw
    "Z" -> Win
  }
}

pub fn score_play(play) {
  let resp_score = score_response(play.response)
  let result_score =
    play
    |> calc_result()
    |> score_result()
  resp_score + result_score
}

pub fn calc_result(play) {
  case play {
    Play1(request: Rock, response: Paper) -> Win
    Play1(request: Rock, response: Scissors) -> Lose
    Play1(request: Paper, response: Rock) -> Lose
    Play1(request: Paper, response: Scissors) -> Win
    Play1(request: Scissors, response: Rock) -> Win
    Play1(request: Scissors, response: Paper) -> Lose
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

pub fn calc_response(request, result) {
  let scenario = #(request, result)
  case scenario {
    #(Rock, Win) -> Paper
    #(Rock, Lose) -> Scissors
    #(Paper, Win) -> Scissors
    #(Paper, Lose) -> Rock
    #(Scissors, Win) -> Rock
    #(Scissors, Lose) -> Paper
    #(req, Draw) -> req
  }
}
