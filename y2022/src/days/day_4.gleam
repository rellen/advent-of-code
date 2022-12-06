import gleam/string
import gleam/list
import gleam/int
import helpers

pub fn pt_1(input: String) -> Int {
  input
  |> helpers.lines()
  |> list.fold(0, fn(acc, line) {
    let [fst, snd] = string.split(line, on: ",")
    let #(a1, b1) = parse_range(fst)
    let #(a2, b2) = parse_range(snd)
    let fst_has_snd = a1 <= a2 && b2 <= b1
    let snd_has_fst = a2 <= a1 && b1 <= b2
    let res = case fst_has_snd || snd_has_fst {
      True -> 1
      False -> 0
    }
    acc + res
  })
}

pub fn pt_2(input: String) -> Int {
  input
  |> helpers.lines()
  |> list.fold(0, fn(acc, line) {
      let [fst, snd] = string.split(line, on: ",")
      let #(a1, b1) = parse_range(fst)
      let #(a2, b2) = parse_range(snd)
      let overlap = b1 >= a2 && a1 <= b2
      let res = case overlap {
        True -> 1
        False -> 0
      }
      acc + res
    })
}

pub fn parse_range(str) {
  let [a_str, b_str] = string.split(str, on: "-")
  assert Ok(a) = int.parse(a_str)
  assert Ok(b) = int.parse(b_str)
  #(a, b)
}
