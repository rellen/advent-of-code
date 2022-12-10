import gleam/string
import gleam/int
import gleam/result
import gleam/list

pub fn lines(str: String) -> List(String) {
  string.split(str, on: "\n")
}

pub fn split_at(str: String, index: Int) -> List(String) {
  let len = string.length(str)
  let first = string.slice(str, at_index: 0, length: index)
  let second = string.slice(str, at_index: index, length: len - index)
  [first, second]
}

pub fn parse_int(str) {
 str |> int.parse() |> result.unwrap(0)
}

pub fn max_in_list(xs,default) {
  xs |> list.reduce(fn(x1, x2){int.max(x1,x2)}) |> result.unwrap(default)
}

pub fn list_at(xs, at) {
assert Ok(result) = list.at(xs, at)
result
}
