import gleam/string
import gleam/int

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
  assert Ok(num) = int.parse(str)
  num
}
